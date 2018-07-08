import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    var swiftWatchConnectivity: WatchConnectivityManager?

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if ProcessInfo.processInfo.isUITesting {
            UIView.setAnimationsEnabled(false)
            CurrentUser.shared.remove()
        }

        self.swiftWatchConnectivity = WatchConnectivityManager()
        self.swiftWatchConnectivity?.start()

        let window = UIWindow(frame: UIScreen.main.bounds)

        self.window = window
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()

        return true
    }
}
