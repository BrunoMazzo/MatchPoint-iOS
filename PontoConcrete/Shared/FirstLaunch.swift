//
//  FirstLaunch.swift
//  PontoConcrete
//
//  Created by Douglas Medeiros on 18/12/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

protocol FirstLaunchDataSource {
    func getWasLaunchedBefore() -> Bool
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool)
}

class FirstLaunch {
    
    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }
    
    init(source: FirstLaunchDataSource) {
        let wasLaunchedBefore = source.getWasLaunchedBefore()
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            source.setWasLaunchedBefore(true)
        }
    }
}

struct AlwaysFirstLaunchDataSource : FirstLaunchDataSource {
    
    func getWasLaunchedBefore() -> Bool {
        return false
    }
    
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool) { }
}

struct UserDefaultsFirstLaunchDataSource : FirstLaunchDataSource {
    
    let defaults: UserDefaults
    let key: String
    
    func getWasLaunchedBefore() -> Bool {
        return defaults.bool(forKey: key)
    }
    
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool) {
        defaults.set(wasLaunchedBefore, forKey: key)
    }
    
}
