import Foundation

final class ProgressStore {
    static let shared = ProgressStore()
    private let defaults = UserDefaults.standard
    private let completedKey = "completedLessonIDs"
    private let pointsKey = "totalPoints"
    private let streakKey = "learningStreak"
    private let lastStudyKey = "lastStudyDate"
    private let badgesKey = "earnedBadges"

    var earnedBadges: Set<String> { Set(defaults.stringArray(forKey: badgesKey) ?? []) }

    func awardBadge(_ identifier: String) {
        var badges = earnedBadges
        badges.insert(identifier)
        defaults.set(Array(badges), forKey: badgesKey)
    }

    var completedIDs: Set<Int> { Set(defaults.array(forKey: completedKey) as? [Int] ?? []) }
    var points: Int { defaults.integer(forKey: pointsKey) }
    var level: Int { max(1, points / 100 + 1) }
    var streak: Int { defaults.integer(forKey: streakKey) }

    func isComplete(_ lesson: Lesson) -> Bool { completedIDs.contains(lesson.id) }

    @discardableResult
    func complete(_ lesson: Lesson) -> Bool {
        var completed = completedIDs
        guard !completed.contains(lesson.id) else { return false }
        completed.insert(lesson.id)
        defaults.set(Array(completed), forKey: completedKey)
        defaults.set(points + 25, forKey: pointsKey)
        updateStreak()
        awardBadge("firstLesson")
        if completed.count >= 7 { awardBadge("weekOne") }
        if completed.count >= 15 { awardBadge("halfway") }
        if completed.count >= 30 { awardBadge("courseComplete") }
        return true
    }

    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = defaults.object(forKey: lastStudyKey) as? Date {
            let previous = Calendar.current.startOfDay(for: last)
            let days = Calendar.current.dateComponents([.day], from: previous, to: today).day ?? 0
            if days == 1 { defaults.set(streak + 1, forKey: streakKey) }
            else if days > 1 { defaults.set(1, forKey: streakKey) }
        } else {
            defaults.set(1, forKey: streakKey)
        }
        defaults.set(today, forKey: lastStudyKey)
    }
}
