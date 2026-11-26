import UIKit

final class LessonViewController: UIViewController {
    private let lesson: Lesson
    private var selectedAnswer: Int?
    private let scrollView = UIScrollView()
    private let feedback = Style.label("Choose an answer to check your understanding.", size: 14)
    private let answersStack = UIStackView()

    init(lesson: Lesson) {
        self.lesson = lesson
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Day \(lesson.id)"
        view.backgroundColor = Style.canvas
        buildUI()
    }

    private func buildUI() {
        let scroll = scrollView; scroll.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView(); stack.axis = .vertical; stack.spacing = 16; stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll); scroll.addSubview(stack)
        NSLayoutConstraint.activate([scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor), scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor), stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 18), stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24), stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20), stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20)])
        stack.addArrangedSubview(Style.label(lesson.title, size: 24, weight: .bold))
        stack.addArrangedSubview(Style.label(lesson.summary, size: 16, weight: .medium))
        let bodyCard = Style.card(); let body = Style.label(lesson.content, size: 16); body.font = .monospacedSystemFont(ofSize: 14, weight: .regular); body.textColor = Style.ink; body.translatesAutoresizingMaskIntoConstraints = false; bodyCard.addSubview(body)
        NSLayoutConstraint.activate([body.topAnchor.constraint(equalTo: bodyCard.topAnchor, constant: 18), body.bottomAnchor.constraint(equalTo: bodyCard.bottomAnchor, constant: -18), body.leadingAnchor.constraint(equalTo: bodyCard.leadingAnchor, constant: 16), body.trailingAnchor.constraint(equalTo: bodyCard.trailingAnchor, constant: -16)])
        stack.addArrangedSubview(bodyCard)
        stack.addArrangedSubview(Style.label("Quick check", size: 20, weight: .bold))
        stack.addArrangedSubview(Style.label(lesson.question, size: 16, weight: .medium))
        answersStack.axis = .vertical; answersStack.spacing = 9
        for (index, option) in lesson.options.enumerated() {
            let button = Style.button(option, action: #selector(selectAnswer(_:)), target: self, filled: false)
            button.tag = index; button.contentHorizontalAlignment = .leading
            button.accessibilityHint = "Select this answer"
            answersStack.addArrangedSubview(button)
        }
        stack.addArrangedSubview(answersStack)
        feedback.textColor = Style.muted; stack.addArrangedSubview(feedback)
        let check = Style.button("Check answer", action: #selector(checkAnswer), target: self)
        stack.addArrangedSubview(check)
    }

    @objc private func selectAnswer(_ sender: UIButton) {
        selectedAnswer = sender.tag
        for case let button as UIButton in answersStack.arrangedSubviews {
            button.backgroundColor = button.tag == sender.tag ? Style.mint : .clear
            button.setTitleColor(Style.green, for: .normal)
        }
        feedback.text = "Answer selected. Tap Check answer when you’re ready."
        feedback.textColor = Style.muted
    }

    @objc private func checkAnswer() {
        guard let selectedAnswer else {
            feedback.text = "Please choose an answer first."
            feedback.textColor = .systemRed
            return
        }
        guard selectedAnswer == lesson.correctAnswer else {
            feedback.text = "Not quite—try another option. You can do it!"
            feedback.textColor = .systemRed
            return
        }
        let earned = ProgressStore.shared.complete(lesson)
        feedback.text = earned ? "Correct! Lesson complete — +25 points 🎉" : "Correct! You’ve already completed this lesson."
        feedback.textColor = Style.green
        for case let button as UIButton in answersStack.arrangedSubviews { button.isEnabled = false }
    }
}
