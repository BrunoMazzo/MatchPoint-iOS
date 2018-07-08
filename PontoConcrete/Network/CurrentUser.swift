import CoreLocation
import KeychainSwift

protocol CurrentUserProtocol: class {
    func isLoggedIn() -> Bool
    func user() -> SessionData?
}

class CurrentUser: CurrentUserProtocol {
    var keychain: KeychainSwift

    static let shared = CurrentUser()

    private init(keychain: KeychainSwift = KeychainSwift()) {
        self.keychain = keychain
    }

    func isLoggedIn() -> Bool {
        guard let token = keychain.get(.token) else {
            return false
        }

        return !token.isEmpty
    }

    func user() -> SessionData? {
        guard let token = keychain.get(.token),
            let clientId = keychain.get(.clientId),
            let email = keychain.get(.email) else {
            return nil
        }
        return SessionData(token: token, clientId: clientId, email: email)
    }

    @discardableResult
    func saveLocation(point: Point) -> Bool {
        return self.keychain.set(point.rawValue, forKey: .location, withAccess: .accessibleAfterFirstUnlock)
    }

    func configLocation() -> Point {
        guard let location = keychain.get(.location), let point = Point(rawValue: location) else {
            return Point.saoPaulo
        }

        return point
    }

    @discardableResult
    func saveConfigNotification(isEnabled: Bool) -> Bool {
        return self.keychain.set(isEnabled, forKey: .notification, withAccess: .accessibleAfterFirstUnlock)
    }

    func configNotification() -> Bool {
        guard let notification = keychain.getBool(.notification) else {
            return false
        }

        return notification
    }

    @discardableResult
    func new(user: SessionData) -> Bool {
        return self.keychain.set(user.token, forKey: .token, withAccess: .accessibleAfterFirstUnlock) && self.keychain.set(user.clientId, forKey: .clientId, withAccess: .accessibleAfterFirstUnlock) && self.keychain.set(user.email, forKey: .email, withAccess: .accessibleAfterFirstUnlock)
    }

    @discardableResult
    func remove() -> Bool {
        return self.keychain.delete(.token) && self.keychain.delete(.clientId)
    }
}
