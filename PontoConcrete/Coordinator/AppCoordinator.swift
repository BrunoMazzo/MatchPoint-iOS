import UIKit

class AppCoordinator: RootViewCoordinator {
    var currentUser: CurrentUserProtocol

    var rootViewController: UIViewController {
        return self.navigationController
    }

    let window: UIWindow

    private(set) lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()

    public init(window: UIWindow) {
        self.window = window

        self.currentUser = CurrentUser.shared
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }

    public func start() {
        if self.currentUser.isLoggedIn() {
            self.showHomeViewController()
        } else {
            self.showLoginViewController()
        }
    }

    private func showLoginViewController() {
        let loginViewController = LoginViewController()
        loginViewController.delegate = self

        self.navigationController.viewControllers = [loginViewController]
    }

    private func showHomeViewController() {
        let homeViewController = HomeViewController()

        homeViewController.delegate = self
        self.navigationController.viewControllers = [homeViewController]
    }
}

extension AppCoordinator: HomeViewControllerDelegate {
    func homeViewControllerDidLogout(viewController _: HomeViewController) {
        self.start()
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
    func loginViewControllerDidTapAutenticate(viewController _: LoginViewController) {
        self.start()
    }
}
