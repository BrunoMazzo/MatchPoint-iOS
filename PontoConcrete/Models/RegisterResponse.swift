//
//  RegisterResponse.swift
//  PontoConcrete
//
//  Created by Douglas Brito de Medeiros on 18/11/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//
import Foundation

struct RegisterResponse: Mappable {
    let timeCard: TimeCard?
    let path: String?
    let device: Device?
    let appVersion: String?

    private enum CodingKeys: String, CodingKey {
        case timeCard = "time_card"
        case path = "_path"
        case device = "_device"
        case appVersion = "_appVersion"
    }
}
