//
//  CLPlacemark.swift
//  MatchPoint
//
//  Created by Douglas Medeiros on 18/11/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//

import CoreLocation

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let subLocality = subLocality {
                result += " - \(subLocality)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let administrativeArea = administrativeArea {
                result += " - \(administrativeArea)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
}
