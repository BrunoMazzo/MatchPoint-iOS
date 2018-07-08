import CoreLocation
import Foundation

public enum Point: String, EnumCollection {
    case saoPaulo, rioDeJaneiro, minasGerais

    public func name() -> String {
        switch self {
        case .saoPaulo:
            return "São Paulo"
        case .rioDeJaneiro:
            return "Rio de Janeiro"
        case .minasGerais:
            return "Minas Gerais"
        }
    }

    func point() -> PointData {
        switch self {
        case .saoPaulo:
            return PointData(location: CLLocation(latitude: -23.601449, longitude: -46.694799), address: "Av. das Nações Unidas, 11541 - Cidade Monções, São Paulo - SP, Brasil")
        case .rioDeJaneiro:
            return PointData(location: CLLocation(latitude: -22.910222, longitude: -43.172658), address: "Av. Presidente Wilson, 231 - Centro, Rio de Janeiro - RJ, Brasil")
        case .minasGerais:
            return PointData(location: CLLocation(latitude: -19.935331, longitude: -43.929717), address: "Av. Getúlio Vargas, 671 - Savassi, Minas Gerais - MG, Brasil")
        }
    }

    func asDict() -> [String: String] {
        return [
            .command: .location,
            .location: self.rawValue,
        ]
    }
}
