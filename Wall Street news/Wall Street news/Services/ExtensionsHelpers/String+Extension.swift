//
//  String+Extension.swift
//  Wall Street news
//
//  Created by Егор on 18.07.2022.
//

import Foundation

// Date formatter

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
