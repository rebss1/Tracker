//
//  Tracker.swift
//  Tracker
//
//  Created by Илья Лощилов on 28.06.2024.
//

import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: String
    
    init(id: UUID, type: TrackerFrequency, name: String, color: String, emoji: String, schedule: String) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
    
    init(_ newTracker: NewTracker) {
        self.id = UUID()
        self.name = newTracker.name
        self.color = newTracker.color
        self.emoji = newTracker.emoji
        self.schedule = newTracker.schedule
    }
}
