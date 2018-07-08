import Foundation
import Moya

protocol IPontoMaisService: class {
    func login(email: String, password: String, callback: @escaping IPontoMaisAPI.LoginCompletion) -> Cancellable
    func register(credentials: SessionData, point: PointData, callback: @escaping IPontoMaisAPI.RegisterCompletion) -> Cancellable
}

class PontoMaisService {
    let api: IPontoMaisAPI

    init(provider: IPontoMaisAPI = PontoMaisAPI()) {
        self.api = provider
    }
}

extension PontoMaisService: IPontoMaisService {
    @discardableResult
    func register(credentials: SessionData, point: PointData, callback: @escaping IPontoMaisAPI.RegisterCompletion) -> Cancellable {
        return self.api.register(credentials: credentials, point: point, callback: callback)
    }

    @discardableResult
    func login(email: String, password: String, callback: @escaping IPontoMaisAPI.LoginCompletion) -> Cancellable {
        return self.api.login(email: email, password: password, callback: callback)
    }
}
