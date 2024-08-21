//
//  DayOfWeek.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.07.2024.
//

import Foundation

enum DayOfWeek: String, CaseIterable {
    case monday = "Mon",
         tuesday = "Tue",
         wednesday = "Wed",
         thursday = "Thu",
         friday = "Fri",
         saturday = "Sat",
         sunday = "Sun"

    var shortName: String {
        switch self {
            case .monday: return "Mon"
            case .tuesday: return "Tue"
            case .wednesday: return "Wed"
            case .thursday: return "Thu"
            case .friday: return "Fri"
            case .saturday: return "Sat"
            case .sunday: return "Sun"
        }
    }

    var fullName: String {
        switch self {
            case .monday: return "Monday"
            case .tuesday: return "Tuesday"
            case .wednesday: return "Wednesday"
            case .thursday: return "Thursday"
            case .friday: return "Friday"
            case .saturday: return "Saturday"
            case .sunday: return "Sunday"
        }
    }

    static func scheduleToString(schedule: [DayOfWeekSwitch]) -> String {
        if schedule.filter({ $0.isEnabled }).count == 7 {
            return "Every day"
        }
        let hasNotWeekend = schedule
            .filter { $0.isEnabled }
            .map { $0.dayOfWeek }
            .filter { $0 == DayOfWeek.saturday || $0 == DayOfWeek.sunday }
            .isEmpty
        if schedule.filter({ $0.isEnabled }).count == 5 && hasNotWeekend {
            return "Waking days"
        }
        return schedule
            .filter { $0.isEnabled }
            .map { $0.dayOfWeek.shortName }
            .joined(separator: ", ")
    }

    static func stringToSchedule(scheduleString: String) -> [DayOfWeekSwitch] {
        if scheduleString.isEmpty {
            return []
        }
        if scheduleString == "Every day" {
            return DayOfWeek.allCases.map { DayOfWeekSwitch(dayOfWeek: $0, isEnabled: true) }
        }
        if scheduleString == "Waking days" {
            return DayOfWeek.allCases[0...4].map { DayOfWeekSwitch(dayOfWeek: $0, isEnabled: true) }
        }
        return scheduleString
            .components(separatedBy: ", ")
            .map { DayOfWeekSwitch(dayOfWeek: DayOfWeek(rawValue: $0) ?? .monday, isEnabled: true) }
    }
}

struct DayOfWeekSwitch {
    let dayOfWeek: DayOfWeek
    var isEnabled: Bool
}
