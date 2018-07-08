//
//  LoginResponse.swift
//  PontoConcrete
//
//  Created by Lucas Salton Cardinali on 13/09/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//
import Foundation

struct LoginResponse: Mappable {
    let token: String?
    let clientId: String?

    private enum CodingKeys: String, CodingKey {
        case token
        case clientId = "client_id"
    }
}
