import FontAwesome
import SwiftyAttributes

public enum LabelAttributed {
    case custom(String)
    case address(String)
    case salutationSuccess(time: Date)
    case start
    case reloadButton
    case buttonTry
    case login
    case errorRequest
    case errorInternet
    case location(String)

    func attributed() -> NSAttributedString {
        let fontAwesome = UIFont.fontAwesome(ofSize: 24)
        switch self {
        case let .location(location):
            return "Meu local ".withFont(.systemFont(ofSize: 14)) + "\u{f101} ".withFont(UIFont.fontAwesome(ofSize: 13)).withTextColor(.white) + location.withFont(.boldSystemFont(ofSize: 15))
        case let .address(address):
            return "Endereço aproximado: ".withFont(.systemFont(ofSize: 11)) + address.withFont(.boldSystemFont(ofSize: 12))
        case let .salutationSuccess(time):
            return "\u{f1ae} ".withFont(fontAwesome) + time.salutation().withFont(.systemFont(ofSize: 24))
        case .start:
            return "\u{f017}".withFont(fontAwesome).withTextColor(.white) + " BATER O PONTO".withFont(.systemFont(ofSize: 24)).withTextColor(.white)
        case .reloadButton:
            return "\u{f021}".withFont(fontAwesome).withTextColor(.catalinaBlue)
        case .buttonTry:
            return "\u{f021}".withFont(fontAwesome).withTextColor(.white) + " Tentar novamente".withFont(.systemFont(ofSize: 24)).withTextColor(.white)
        case .errorRequest:
            return "\u{f071}".withFont(UIFont.fontAwesome(ofSize: 13)) + "Ops.. houve um problema no request, tente novamente".withFont(.systemFont(ofSize: 13)).withTextColor(.black)
        case .login:
            return "Se logue no app para poder bater o ponto!".withFont(.systemFont(ofSize: 15)).withTextColor(.black)
        case let .custom(message):
            return message.withFont(.systemFont(ofSize: 15)).withTextColor(.black)
        case .errorInternet:
            return "Verifique sua conexão com a internet!".withFont(.systemFont(ofSize: 15)).withTextColor(.black)
        }
    }
}
