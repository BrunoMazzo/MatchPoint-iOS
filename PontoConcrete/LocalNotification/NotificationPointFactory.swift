import Foundation

enum NotificationPointFactory {
    static func notification(for point: Point) -> NotificationPoint {
        switch point {
        case .saoPaulo:
            return NotificationPointSP(content: NotificationDefaultContent())
        case .rioDeJaneiro:
            return NotificationPointRJ(content: NotificationDefaultContent())
        case .minasGerais:
            return NotificationPointBH(content: NotificationDefaultContent())
        }
    }
}
