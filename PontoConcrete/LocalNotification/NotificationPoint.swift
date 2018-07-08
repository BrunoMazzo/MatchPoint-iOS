import CoreLocation
import UserNotifications

protocol NotificationPoint {
    var point: Point { get }
    var name: String { get }
    func request() -> UNNotificationRequest
}
