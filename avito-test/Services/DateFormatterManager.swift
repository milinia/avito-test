//
//  DateFormatterManager.swift
//  avito-test
//
//  Created by Evelina on 26.08.2023.
//

import Foundation

protocol DateFormatterManagerProtocol {
    func formatDate(stringDate: String) -> String?
}

final class DateFormatterManager:DateFormatterManagerProtocol {
    
    func formatDate(stringDate: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: -10800)
        guard let date = dateFormatter.date(from: stringDate) else {return nil}
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(from: date)
    }
}
