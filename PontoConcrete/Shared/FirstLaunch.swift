import Foundation

protocol FirstLaunchDataSource {
    func getWasLaunchedBefore() -> Bool
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool)
}

class FirstLaunch {
    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !self.wasLaunchedBefore
    }

    init(source: FirstLaunchDataSource) {
        let wasLaunchedBefore = source.getWasLaunchedBefore()
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            source.setWasLaunchedBefore(true)
        }
    }
}

struct AlwaysFirstLaunchDataSource: FirstLaunchDataSource {
    func getWasLaunchedBefore() -> Bool {
        return false
    }

    func setWasLaunchedBefore(_: Bool) {}
}

struct UserDefaultsFirstLaunchDataSource: FirstLaunchDataSource {
    let defaults: UserDefaults
    let key: String

    func getWasLaunchedBefore() -> Bool {
        return self.defaults.bool(forKey: self.key)
    }

    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool) {
        self.defaults.set(wasLaunchedBefore, forKey: self.key)
    }
}
