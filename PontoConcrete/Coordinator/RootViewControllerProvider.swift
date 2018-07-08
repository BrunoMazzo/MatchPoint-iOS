import UIKit

public protocol RootViewControllerProvider: class {
    var rootViewController: UIViewController { get }
}

public typealias RootViewCoordinator = RootViewControllerProvider
