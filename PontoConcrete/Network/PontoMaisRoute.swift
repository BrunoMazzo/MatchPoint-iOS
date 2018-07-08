//
//  PontoMaisRoute.swift
//  PontoConcrete
//
//  Created by Lucas Salton Cardinali on 13/09/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//
import Moya

enum PontoMaisRoute {
    case login(login: String, password: String)
    case register(data: SessionData, point: PointData)
}

extension PontoMaisRoute: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.pontomaisweb.com.br") else {
            fatalError("Base URL invalid")
        }
        return url
    }

    var path: String {
        switch self {
        case .login:
            return "/api/auth/sign_in"
        case .register:
            return "/api/time_cards/register"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .register:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .register(_, point):

            let latitude = String(format: "%.7f", point.location.coordinate.latitude)
            let longitude = String(format: "%.7f", point.location.coordinate.longitude)
            let address = point.address

            return .requestParameters(parameters: [
                "time_card": [
                    "latitude": latitude,
                    "longitude": longitude,
                    "address": address,
                    "reference_id": "",
                    "original_latitude": latitude,
                    "original_longitude": longitude,
                    "original_address": address,
                    "location_edited": false,
                    "accuracy": 30,
                ],
                "_path": "/meu_ponto/registro_de_ponto",
                "_device": [
                    "cordova": "4.1.0",
                    "manufacturer": "unknown",
                    "model": "Chrome",
                    "platform": "browser",
                    "uuid": nil,
                    "version": "61.0.3163.79",
                ],
                "_appVersion": "0.10.21",
            ], encoding: JSONEncoding.default)

        case let .login(login, password):
            return .requestParameters(parameters: ["login": login, "password": password],
                                      encoding: JSONEncoding.default)
        }
    }

    var sampleData: Data {
        var json = ""

        switch self {
        case let .login(login, password):
            if login == "email@concrete.com.br" && password == "123456" {
                json = "{\"success\":\"Login efetuado com sucesso!\",\"token\":\"AqT_IHCKzjRJkK6sEXDl_A\",\"client_id\":\"BkBLDY_tHZt859U6100eKA\",\"data\":{\"email\":\"email@concrete.com.br\",\"sign_in_count\":39,\"last_sign_in_ip\":\"189.199.195.159\",\"last_sign_in_at\":1511031962},\"meta\":{\"now\":1511032411,\"ip\":\"189.199.195.159\"}}"
            } else {
                json = "{\"error\":\"Usuário e/ou senha inválidos\",\"meta\":{\"now\":1511032961,\"ip\":\"179.35.195.159\"}}"
            }
        case let .register(_, point):

            if point.address == "Street 1" {
                json = "{\"success\":\"Ponto registrado com sucesso\",\"untreated_time_card\":{\"id\":10692079,\"time_clock_id\":null,\"time_clock_sequence_number\":null,\"nis\":null,\"time\":\"2000-01-01T17:25:44.000Z\",\"date\":\"2017-11-18\",\"source\":4,\"processed\":true,\"deleted_at\":null,\"created_at\":\"2017-11-18T17:25:44.151-02:00\",\"updated_at\":\"2017-11-18T17:25:44.151-02:00\",\"latitude\":null,\"longitude\":null,\"user_id\":66417,\"original_latitude\":null,\"original_longitude\":null,\"location_edited\":null,\"accuracy\":null,\"accuracy_method\":null,\"address\":null,\"original_address\":null,\"image_file_name\":null,\"image_content_type\":null,\"image_file_size\":null,\"image_updated_at\":null,\"ip\":\"179.35.195.159\",\"reference_id\":null,\"offline\":false},\"time_card\":{\"id\":15521172,\"employee_id\":89812,\"nis\":null,\"time\":\"2000-01-01T17:25:44.000Z\",\"date\":\"2017-11-18\",\"source\":4,\"time_clock_id\":null,\"time_clock_sequence_number\":null,\"register_type\":1,\"disabled\":false,\"deleted_at\":null,\"created_at\":\"2017-11-18T17:25:44.352-02:00\",\"updated_at\":\"2017-11-18T17:25:44.352-02:00\",\"work_day_id\":17499537,\"latitude\":null,\"longitude\":null,\"updated_by_id\":null,\"user_id\":66417,\"is_in_allowance\":null,\"status_id\":null,\"original_latitude\":null,\"original_longitude\":null,\"location_edited\":null,\"accuracy\":null,\"accuracy_method\":null,\"address\":null,\"original_address\":null,\"untreated_id\":10692079,\"ip\":\"179.35.195.159\",\"reference_id\":null,\"offline\":false,\"local_date_time\":null},\"receipt\":\"00010692079\",\"meta\":{\"now\":1511033144,\"ip\":\"179.35.195.159\"}}"
            } else {
                json = "{\"error\":\"Erro ao tentar bater o ponto\",\"meta\":{\"now\":1511033144,\"ip\":\"179.35.195.159\"}}"
            }
        }

        guard let data = json.data(using: .utf8) else {
            fatalError("Error sample data JSON")
        }
        return data
    }

    var headers: [String: String]? {
        var customHeaders = ["Content-type": "application/json"]

        switch self {
        case let .register(data, _):
            customHeaders["access-token"] = data.token
            customHeaders["client"] = data.clientId
            customHeaders["uid"] = data.email
        default:
            return customHeaders
        }
        return customHeaders
    }
}
