import UIKit

final class DashboardViewController: UIViewController {
    private let lessons = CourseRepository.shared.loadLessons()
    private let progress = ProgressStore.shared
    private let quoteLabel = Style.label("A little learning every day adds up.", size: 14)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Python in 30 Days"
        view.backgroundColor = Style.canvas
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Awards", style: .plain, target: self, action: #selector(showAwards))
        buildUI()
        LessonService.shared.fetchDailyQuote { [weak self] quote in
            guard let quote else { return }
            self?.quoteLabel.text = quote
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshProgress()
    }

    private let progressLabel = Style.label("", size: 15, weight: .medium)
    private let pointsLabel = Style.label("", size: 15, weight: .semibold)
    private let streakLabel = Style.label("", size: 15, weight: .semibold)
    private let bar = UIProgressView(progressViewStyle: .default)
    private let greeting = Style.label("", size: 26, weight: .bold)

    private func buildUI() {
        let scroll = UIScrollView()
        let stack = UIStackView()
        stack.axis = .vertical; stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll); scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 18), stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20), stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20)
        ])
        greeting.text = "Your next small win starts here."
        stack.addArrangedSubview(greeting)

        let stats = Style.card()
        let statStack = UIStackView(arrangedSubviews: [pointsLabel, streakLabel])
        statStack.distribution = .fillEqually; statStack.spacing = 8; statStack.translatesAutoresizingMaskIntoConstraints = false
        stats.addSubview(statStack)
        NSLayoutConstraint.activate([statStack.topAnchor.constraint(equalTo: stats.topAnchor, constant: 18), statStack.bottomAnchor.constraint(equalTo: stats.bottomAnchor, constant: -18), statStack.leadingAnchor.constraint(equalTo: stats.leadingAnchor, constant: 16), statStack.trailingAnchor.constraint(equalTo: stats.trailingAnchor, constant: -16)])
        stack.addArrangedSubview(stats)

        let course = Style.card()
        let courseStack = UIStackView(); courseStack.axis = .vertical; courseStack.spacing = 12; courseStack.translatesAutoresizingMaskIntoConstraints = false
        courseStack.addArrangedSubview(Style.label("30-day course", size: 18, weight: .bold))
        courseStack.addArrangedSubview(progressLabel)
        bar.progressTintColor = Style.green; bar.trackTintColor = Style.mint; bar.heightAnchor.constraint(equalToConstant: 8).isActive = true
        courseStack.addArrangedSubview(bar)
        let continueButton = Style.button("Continue learning", action: #selector(showLessons), target: self)
        courseStack.addArrangedSubview(continueButton)
        course.addSubview(courseStack)
        NSLayoutConstraint.activate([courseStack.topAnchor.constraint(equalTo: course.topAnchor, constant: 18), courseStack.bottomAnchor.constraint(equalTo: course.bottomAnchor, constant: -18), courseStack.leadingAnchor.constraint(equalTo: course.leadingAnchor, constant: 18), courseStack.trailingAnchor.constraint(equalTo: course.trailingAnchor, constant: -18)])
        stack.addArrangedSubview(course)

        let quoteCard = Style.card()
        quoteLabel.font = .italicSystemFont(ofSize: 14); quoteLabel.textColor = Style.muted
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false; quoteCard.addSubview(quoteLabel)
        NSLayoutConstraint.activate([quoteLabel.topAnchor.constraint(equalTo: quoteCard.topAnchor, constant: 16), quoteLabel.bottomAnchor.constraint(equalTo: quoteCard.bottomAnchor, constant: -16), quoteLabel.leadingAnchor.constraint(equalTo: quoteCard.leadingAnchor, constant: 16), quoteLabel.trailingAnchor.constraint(equalTo: quoteCard.trailingAnchor, constant: -16)])
        stack.addArrangedSubview(quoteCard)
        let lessonButton = Style.button("Browse all lessons", action: #selector(showLessons), target: self, filled: false)
        stack.addArrangedSubview(lessonButton)
    }

    private func refreshProgress() {
        let done = progress.completedIDs.count
        progressLabel.text = "Level \(progress.level)  ·  \(done) of \(lessons.count) lessons completed"
        pointsLabel.text = "⭐  \(progress.points) points"
        streakLabel.text = "🔥  \(progress.streak) day streak"
        bar.setProgress(lessons.isEmpty ? 0 : Float(done) / Float(lessons.count), animated: true)
    }

    @objc private func showLessons() {
        navigationController?.pushViewController(LessonsViewController(), animated: true)
    }
    @objc private func showAwards() {
        navigationController?.pushViewController(AchievementsViewController(), animated: true)
    }
}
