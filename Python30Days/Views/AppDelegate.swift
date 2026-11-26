import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = storyboard.instantiateInitialViewController()
#if DEBUG
        showRequestedReportScreenIfNeeded()
#endif
        window?.makeKeyAndVisible()
        return true
    }

#if DEBUG
    private func showRequestedReportScreenIfNeeded() {
        guard let navigation = window?.rootViewController as? UINavigationController,
              let argument = ProcessInfo.processInfo.arguments.first(where: { $0.hasPrefix("--report-screen=") }) else { return }
        let screen = String(argument.dropFirst("--report-screen=".count))
        switch screen {
        case "lessons":
            navigation.pushViewController(LessonsViewController(), animated: false)
        case "achievements":
            navigation.pushViewController(AchievementsViewController(), animated: false)
        case "lesson":
            guard let lesson = CourseRepository.shared.loadLessons().first(where: { $0.id == 3 }) else { return }
            navigation.pushViewController(LessonViewController(lesson: lesson), animated: false)
        default:
            break
        }
    }
#endif
}
