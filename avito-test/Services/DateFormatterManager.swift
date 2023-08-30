//
//  DateFormatterManager.swift
//  avito-test
//
//  Created by Evelina on 26.08.2023.
//

import Foundation

protocol DateFormatterManagerProtocol {
    func formatDate(stringDate: String) -> String
}

final class DateFormatterManager:DateFormatterManagerProtocol {
    
    func formatDate(stringDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-mm-dd"
        let date = dateFormatter.date(from: stringDate) ?? Date()
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(from: date)
    }
}
