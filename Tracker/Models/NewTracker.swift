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
    var frequency: TrackerFrequency
    var name: String
    var color: String
    var emoji: String
    var schedule: String
    var categoryName: String
    var createdAt: Date
    
    init(
        frequency: TrackerFrequency,
        name: String,
        color: String,
        emoji: String,
        schedule: String,
        categoryName: String,
        createdAt: Date?
    ) {
        self.frequency = frequency
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.categoryName = categoryName
        self.createdAt = createdAt ?? Date()
    }

    init(from tracker: Tracker) {
        self.name = tracker.name
        self.color = tracker.color
        self.emoji = tracker.emoji
        self.schedule = tracker.schedule
        self.categoryName = tracker.categoryName
        self.frequency = tracker.schedule.isEmpty ? .single : .regular
        self.createdAt = tracker.createdAt
    }
}
