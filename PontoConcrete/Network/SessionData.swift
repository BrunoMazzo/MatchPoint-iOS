import Foundation

public struct SessionData {
    let token: String
    let clientId: String
    let email: String

    func asDict() -> [String: String] {
        return [
            .command: .login,
            .token: token,
            .email: email,
            .clientId: clientId,
        ]
    }
}
