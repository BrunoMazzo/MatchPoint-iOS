import UIKit

extension UIFont {
    static var avenirBook: UIFont {
        guard let font = UIFont(name: "Avenir-Book", size: 16) else {
            fatalError("Invalid font name")
        }
        return font
    }

    static var avenirHeavy: UIFont {
        guard let font = UIFont(name: "Avenir-Heavy", size: 16) else {
            fatalError("Invalid font name")
        }
        return font
    }
}
