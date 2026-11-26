import Foundation

final class CourseRepository {
    static let shared = CourseRepository()
    private init() {}

    func loadLessons() -> [Lesson] {
        guard let url = Bundle.main.url(forResource: "Lessons", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let lessons = try? JSONDecoder().decode([Lesson].self, from: data) else { return [] }
        return lessons
    }
}
