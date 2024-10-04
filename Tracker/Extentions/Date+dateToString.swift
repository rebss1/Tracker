//
//  Date+dateToString.swift
//  Tracker
//
//  Created by Илья Лощилов on 30.07.2024.
//

import Foundation

extension Date {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = NSLocalizedString("dateFormat", comment: "")
        formatter.locale = Locale(identifier: "en")
        return formatter
    }()
    
    func dateToString() -> String {
        return Date.dateFormatter.string(from: self).lowercased()
    }
}
