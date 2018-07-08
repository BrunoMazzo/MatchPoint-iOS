import Foundation
import UserNotifications

class UserNotificationCenter {
    var authorizationStatusCallback: ((_ granted: Bool) -> Void)?

    let center: UNUserNotificationCenter
    let options: UNAuthorizationOptions

    init(center: UNUserNotificationCenter = UNUserNotificationCenter.current(),
         options: UNAuthorizationOptions = [.alert, .sound]) {
        self.center = center
        self.options = options
    }

    func requestNotifications() {
        self.center.requestAuthorization(options: self.options) { granted, error in
            if !granted {
                print("Something went wrong: \(error?.localizedDescription ?? "error")")
                return
            }
            self.setupNotifications()
        }
    }

    private func setupNotifications() {
        self.removeAll()

        self.center.add(NotificationPointFactory.notification(for: .saoPaulo).request())
        self.center.add(NotificationPointFactory.notification(for: .rioDeJaneiro).request())
        self.center.add(NotificationPointFactory.notification(for: .minasGerais).request())
    }

    func removeAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
