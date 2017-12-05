//
//  LabelAttributed.swift
//  MatchPoint WatchOS Extension
//
//  Created by Douglas Medeiros on 20/11/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//

import SwiftyAttributes

public enum LabelAttributed {
    case custom(String)
    case salutationSuccess(time: Date)
    case start
    case login
    case loading
    case request
    case permission
    
    func attributed() -> NSAttributedString {
        
        switch self {
        case .salutationSuccess(let time):
            return time.salutation().withFont(.systemFont(ofSize: 24)).withTextColor(.white)
        case .start:
            return "BATER O PONTO".withFont(.systemFont(ofSize: 24)).withTextColor(.white)
        case .login:
            return "Se logue no app para poder bater o ponto!".withFont(.systemFont(ofSize: 16)).withTextColor(.white)
        case .request:
            return "Houve um problema ao tentar obter sua localização.".withFont(.systemFont(ofSize: 16)).withTextColor(.white)
        case .permission:
            return "O acesso à localização foi negado, ative-a nas Configurações".withFont(.systemFont(ofSize: 16)).withTextColor(.white)
        case .loading:
            return "Aguarde...".withFont(.systemFont(ofSize: 22)).withTextColor(.white)
        case .custom(let message):
            return message.withFont(.systemFont(ofSize: 16)).withTextColor(.white)
        }
    }
}
