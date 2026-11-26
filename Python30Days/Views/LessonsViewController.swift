import UIKit

final class LessonsViewController: UITableViewController {
    private let lessons = CourseRepository.shared.loadLessons()
    private let progress = ProgressStore.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lessons"
        tableView.backgroundColor = Style.canvas
        tableView.separatorStyle = .none
        tableView.register(LessonCell.self, forCellReuseIdentifier: LessonCell.reuseID)
    }
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); tableView.reloadData() }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { lessons.count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LessonCell.reuseID, for: indexPath) as! LessonCell
        let lesson = lessons[indexPath.row]
        cell.configure(lesson, complete: progress.isComplete(lesson))
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(LessonViewController(lesson: lessons[indexPath.row]), animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { 92 }
}

private final class LessonCell: UITableViewCell {
    static let reuseID = "LessonCell"
    private let titleLabel = Style.label("", size: 16, weight: .semibold)
    private let detailLabel = Style.label("", size: 13)
    private let statusLabel = Style.label("", size: 13, weight: .semibold)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear; selectionStyle = .none
        let card = Style.card(); card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)
        let stack = UIStackView(arrangedSubviews: [titleLabel, detailLabel, statusLabel]); stack.axis = .vertical; stack.spacing = 6; stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)
        NSLayoutConstraint.activate([card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5), card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5), card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16), card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16), stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 14), stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14), stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16), stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(_ lesson: Lesson, complete: Bool) {
        titleLabel.text = lesson.title; detailLabel.text = lesson.summary
        statusLabel.text = complete ? "✓ Completed" : "• Ready to learn"
        statusLabel.textColor = complete ? Style.green : Style.muted
        accessibilityLabel = "\(lesson.title), \(complete ? "completed" : "ready to learn")"
    }
}
