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
    
    // Свойство для русскоязычного названия
    var russian: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
        
    // Метод для сравнения с русским или английским значением
    static func from(string: String) -> DayOfWeek? {
        switch string {
        case "Mon", "Пн":
            return .monday
        case "Tue", "Вт":
            return .tuesday
        case "Wed", "Ср":
            return .wednesday
        case "Thu", "Чт":
            return .thursday
        case "Fri", "Пт":
            return .friday
        case "Sat", "Сб":
            return .saturday
        case "Sun", "Вс":
            return .sunday
        default:
            return nil
        }
    }

    var shortName: String {
        switch self {
        case .monday: return NSLocalizedString("mondayShort", comment: "")
        case .tuesday: return NSLocalizedString("tuesdayShort", comment: "")
        case .wednesday: return NSLocalizedString("wednesdayShort", comment: "")
        case .thursday: return NSLocalizedString("thursdayShort", comment: "")
        case .friday: return NSLocalizedString("fridayShort", comment: "")
        case .saturday: return NSLocalizedString("saturdayShort", comment: "")
        case .sunday: return NSLocalizedString("sundayShort", comment: "")
        }
    }

    var fullName: String {
        switch self {
            case .monday: return NSLocalizedString("monday", comment: "")
            case .tuesday: return NSLocalizedString("tuesday", comment: "")
            case .wednesday: return NSLocalizedString("wednesday", comment: "")
            case .thursday: return NSLocalizedString("thursday", comment: "")
            case .friday: return NSLocalizedString("friday", comment: "")
            case .saturday: return NSLocalizedString("saturday", comment: "")
            case .sunday: return NSLocalizedString("sunday", comment: "")
        }
    }

    static func scheduleToString(schedule: [DayOfWeekSwitch]) -> String {
        if schedule.filter({ $0.isEnabled }).count == 7 {
            return NSLocalizedString("scheduleEveryday", comment: "")
        }
        let hasNotWeekend = schedule
            .filter { $0.isEnabled }
            .map { $0.dayOfWeek }
            .filter { $0 == DayOfWeek.saturday || $0 == DayOfWeek.sunday }
            .isEmpty
        if schedule.filter({ $0.isEnabled }).count == 5 && hasNotWeekend {
            return NSLocalizedString("scheduleWorkingDay", comment: "")
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
        if scheduleString == NSLocalizedString("scheduleEveryday", comment: "") {
            return DayOfWeek.allCases.map { DayOfWeekSwitch(dayOfWeek: $0, isEnabled: true) }
        }
        if scheduleString == NSLocalizedString("scheduleWorkingDay", comment: "") {
            return DayOfWeek.allCases[0...4].map { DayOfWeekSwitch(dayOfWeek: $0, isEnabled: true) }
        }
        return scheduleString.components(separatedBy: ", ").map { DayOfWeekSwitch(dayOfWeek: DayOfWeek.from(string: $0) ?? .monday, isEnabled: true) }
    }
}

struct DayOfWeekSwitch {
    let dayOfWeek: DayOfWeek
    var isEnabled: Bool
}
