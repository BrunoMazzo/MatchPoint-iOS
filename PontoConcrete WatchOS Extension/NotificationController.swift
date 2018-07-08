import Foundation
import UserNotifications
import WatchKit

class NotificationController: WKUserNotificationInterfaceController {
    @IBOutlet private(set) var notificationAlertLabel: WKInterfaceLabel?

    override init() {
        super.init()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
        self.notificationAlertLabel?.setText(notification.request.content.body)
        completionHandler(.custom)
    }
}
