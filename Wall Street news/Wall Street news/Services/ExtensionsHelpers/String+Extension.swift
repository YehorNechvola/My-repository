

import Foundation

//MARK: - Date Formatter

extension String {
    
    func format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let date = dateFormatter.date(from: self) else { return "error" }
        dateFormatter.dateStyle = .medium
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}
