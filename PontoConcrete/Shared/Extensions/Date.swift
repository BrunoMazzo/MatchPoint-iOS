import Foundation

extension Date {
    func salutation() -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "pt_BR")

        guard let timeZone = TimeZone(identifier: "America/Sao_Paulo") else {
            return ""
        }

        calendar.timeZone = timeZone

        let hour = calendar.component(.hour, from: self)

        var message = ""

        if hour >= 0 && hour <= 11 {
            message = "Bom Trabalho!"
        } else if hour >= 12 && hour <= 13 {
            message = "Bom Almoço!"
        } else if hour >= 14 && hour <= 16 {
            message = "Bom Trabalho!"
        } else if hour >= 17 && hour <= 23 {
            message = "Boa Volta!"
        }

        return message.uppercased()
    }
}
