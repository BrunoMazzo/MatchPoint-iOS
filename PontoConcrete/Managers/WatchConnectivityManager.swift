import Foundation

class WatchConnectivityManager: NSObject {
    let watchConnectivity: SwiftWatchConnectivity
    let notificationCenter: NotificationCenter

    init(watchConnectivity: SwiftWatchConnectivity = SwiftWatchConnectivity.shared,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.watchConnectivity = watchConnectivity
        self.notificationCenter = notificationCenter
        super.init()
    }

    func start() {
        self.watchConnectivity.delegate = self
    }
}

extension WatchConnectivityManager: SwiftWatchConnectivityDelegate {
    func connectivity(_: SwiftWatchConnectivity, updatedWithTask task: SwiftWatchConnectivity.Task) {
        if case let .sendMessage(message) = task {
            guard let command = message[.command] as? String else {
                return
            }

            if command == .login {
                guard let currentUser = CurrentUser.shared.user() else {
                    let data: [String: String] = [
                        .command: .logout,
                    ]

                    DispatchQueue.main.async {
                        self.watchConnectivity.sendMesssage(message: data)
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.watchConnectivity.sendMesssage(message: currentUser.asDict())
                }
            } else if command == .location {
                DispatchQueue.main.async {
                    self.watchConnectivity.sendMesssage(message: Point.saoPaulo.asDict())
                }
            } else if command == .headquarter {
                guard let headquarter = message[.headquarter] as? String, let point = Point(rawValue: headquarter) else {
                    return
                }

                let userInfo: [AnyHashable: Any] = [.location: point.rawValue]
                self.notificationCenter.post(name: .locationChanged, object: self, userInfo: userInfo)
            }
        }
    }
}
