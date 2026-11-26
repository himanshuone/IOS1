import UIKit

final class AchievementsViewController: UIViewController {
    private let store = ProgressStore.shared
    private let badgeList: [(String, String, String, Int)] = [
        ("firstLesson", "First Steps", "Complete your first lesson", 1),
        ("weekOne", "Week One", "Complete any 7 lessons", 7),
        ("halfway", "Halfway Hero", "Complete 15 lessons", 15),
        ("courseComplete", "Python Graduate", "Complete all 30 lessons", 30)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your achievements"
        view.backgroundColor = Style.canvas
        buildUI()
    }
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); buildUI() }

    private func buildUI() {
        view.subviews.forEach { $0.removeFromSuperview() }
        let scroll = UIScrollView(); scroll.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView(); stack.axis = .vertical; stack.spacing = 14; stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll); scroll.addSubview(stack)
        NSLayoutConstraint.activate([scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor), scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor), stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20), stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24), stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20), stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20)])

        let completed = store.completedIDs.count
        let summary = Style.card()
        let summaryStack = UIStackView(arrangedSubviews: [Style.label("Level \(store.level)", size: 24, weight: .bold), Style.label("⭐  \(store.points) points     🔥  \(store.streak)-day streak", size: 16, weight: .medium), Style.label("\(completed) of 30 lessons complete", size: 14)])
        summaryStack.axis = .vertical; summaryStack.spacing = 9; summaryStack.translatesAutoresizingMaskIntoConstraints = false; summary.addSubview(summaryStack)
        NSLayoutConstraint.activate([summaryStack.topAnchor.constraint(equalTo: summary.topAnchor, constant: 18), summaryStack.bottomAnchor.constraint(equalTo: summary.bottomAnchor, constant: -18), summaryStack.leadingAnchor.constraint(equalTo: summary.leadingAnchor, constant: 18), summaryStack.trailingAnchor.constraint(equalTo: summary.trailingAnchor, constant: -18)])
        stack.addArrangedSubview(summary)
        stack.addArrangedSubview(Style.label("Badges", size: 21, weight: .bold))
        for badge in badgeList {
            let earned = store.earnedBadges.contains(badge.0)
            let row = Style.card()
            let label = Style.label("\(earned ? "🏅" : "🔒")  \(badge.1)\n\(badge.2)", size: 15, weight: .semibold)
            label.textColor = earned ? Style.ink : Style.muted; label.translatesAutoresizingMaskIntoConstraints = false; row.addSubview(label)
            NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: row.topAnchor, constant: 16), label.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -16), label.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16), label.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16)])
            stack.addArrangedSubview(row)
        }
        let levels = Style.card()
        let levelText = Style.label("Levels\nLevel 1: 0 points  ·  Level 2: 100 points\nLevel 3: 200 points and onward", size: 14)
        levelText.translatesAutoresizingMaskIntoConstraints = false; levels.addSubview(levelText)
        NSLayoutConstraint.activate([levelText.topAnchor.constraint(equalTo: levels.topAnchor, constant: 16), levelText.bottomAnchor.constraint(equalTo: levels.bottomAnchor, constant: -16), levelText.leadingAnchor.constraint(equalTo: levels.leadingAnchor, constant: 16), levelText.trailingAnchor.constraint(equalTo: levels.trailingAnchor, constant: -16)])
        stack.addArrangedSubview(levels)
    }
}
