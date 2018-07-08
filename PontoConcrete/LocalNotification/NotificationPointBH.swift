import CoreLocation
import UserNotifications

class NotificationPointBH: NotificationPoint {
    let content: UNMutableNotificationContent

    var point: Point {
        return .minasGerais
    }

    var name: String {
        return "ConcreteBH"
    }

    init(content: UNMutableNotificationContent) {
        self.content = content
    }

    func request() -> UNNotificationRequest {
        let region = CLCircularRegion(center: point.point().location.coordinate, radius: 100, identifier: name)
        region.notifyOnExit = true
        region.notifyOnEntry = true

        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)

        return UNNotificationRequest(identifier: self.name, content: self.content, trigger: trigger)
    }
}
