import Foundation
import Moya
import Result

protocol IPontoMaisAPI {
    typealias LoginCompletion = (_ response: LoginResponse?, _ result: Result<Moya.Response, MoyaError>) -> Void
    typealias RegisterCompletion = (_ response: RegisterResponse?, _ result: Result<Moya.Response, MoyaError>) -> Void

    func login(email: String, password: String, callback: @escaping LoginCompletion) -> Cancellable
    func register(credentials: SessionData, point: PointData, callback: @escaping RegisterCompletion) -> Cancellable
}

class PontoMaisAPI: NSObject {
    let provider: MoyaProvider<PontoMaisRoute>

    init(provider: MoyaProvider<PontoMaisRoute> = MoyaProvider<PontoMaisRoute>()) {
        self.provider = provider
    }
}

extension PontoMaisAPI: IPontoMaisAPI {
    @discardableResult
    func register(credentials: SessionData, point: PointData, callback: @escaping IPontoMaisAPI.RegisterCompletion) -> Cancellable {
        return self.provider.request(.register(data: credentials, point: point)) { result in
            switch result {
            case let .success(response):
                guard let responseString = String(data: response.data, encoding: .utf8) else {
                    return callback(nil, result)
                }
                let register = RegisterResponse(jsonString: responseString)
                callback(register, result)
            case .failure:
                callback(nil, result)
            }
        }
    }

    @discardableResult
    func login(email: String, password: String, callback: @escaping IPontoMaisAPI.LoginCompletion) -> Cancellable {
        return self.provider.request(.login(login: email, password: password)) { result in
            switch result {
            case let .success(response):
                guard let responseString = String(data: response.data, encoding: .utf8) else {
                    return callback(nil, result)
                }
                let login = LoginResponse(jsonString: responseString)
                callback(login, result)
            case .failure:
                callback(nil, result)
            }
        }
    }
}
