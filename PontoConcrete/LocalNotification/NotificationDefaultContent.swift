import Foundation
import UserNotifications

class NotificationDefaultContent: UNMutableNotificationContent {
    override init() {
        super.init()
        title = "PontoConcrete"
        body = "Está chegando/saindo da Concrete? Não esqueça de bater o ponto!"
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
