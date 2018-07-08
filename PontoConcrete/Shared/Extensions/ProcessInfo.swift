import Foundation

extension ProcessInfo {
    var isUITesting: Bool {
        return arguments.contains("isUITesting")
    }
}
