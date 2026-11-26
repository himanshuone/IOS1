import UIKit

enum Style {
    static let ink = UIColor(red: 0.10, green: 0.17, blue: 0.20, alpha: 1)
    static let green = UIColor(red: 0.10, green: 0.49, blue: 0.39, alpha: 1)
    static let mint = UIColor(red: 0.88, green: 0.95, blue: 0.91, alpha: 1)
    static let muted = UIColor.secondaryLabel
    static let canvas = UIColor.systemGroupedBackground

    static func label(_ text: String, size: CGFloat, weight: UIFont.Weight = .regular) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = ink
        label.numberOfLines = 0
        return label
    }

    static func button(_ title: String, action: Selector, target: Any, filled: Bool = true) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = filled ? green : .clear
        button.setTitleColor(filled ? .white : green, for: .normal)
        button.layer.cornerRadius = 14
        button.layer.borderWidth = filled ? 0 : 1
        button.layer.borderColor = green.cgColor
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }

    static func card() -> UIView {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 18
        return view
    }
}
