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
            return NSLocalizedString("scheduleWorkingday", comment: "")
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
        if scheduleString == NSLocalizedString("scheduleWorkingday", comment: "") {
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
