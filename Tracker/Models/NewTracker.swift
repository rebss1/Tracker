//
//  NewTracker.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.07.2024.
//

import Foundation

enum TrackerFrequency {
    case regular
    case single
}

struct NewTracker {
    let frequency: TrackerFrequency
    let name: String
    let color: String
    let emoji: String
    let schedule: String

    func update(frequency: TrackerFrequency) -> Self {
        .init(frequency: frequency, name: name, color: color, emoji: emoji, schedule: schedule)
    }

    func update(name: String) -> Self {
        .init(frequency: frequency, name: name, color: color, emoji: emoji, schedule: schedule)
    }

    func update(color: String) -> Self {
        .init(frequency: frequency, name: name, color: color, emoji: emoji, schedule: schedule)
    }

    func update(emoji: String) -> Self {
        .init(frequency: frequency, name: name, color: color, emoji: emoji, schedule: schedule)
    }

    func update(schedule: String) -> Self {
        .init(frequency: frequency, name: name, color: color, emoji: emoji, schedule: schedule)
    }
}
