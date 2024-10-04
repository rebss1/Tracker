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
    let createdAt: Date
    let categoryName: String
    
    init(id: UUID,
         name: String,
         color: String,
         emoji: String,
         schedule: String,
         createdAt: Date,
         categoryName: String)
    {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.createdAt = createdAt
        self.categoryName = categoryName
    }
    
    init(_ newTracker: NewTracker) {
        self.id = UUID()
        self.name = newTracker.name
        self.color = newTracker.color
        self.emoji = newTracker.emoji
        self.schedule = newTracker.schedule
        self.createdAt = Date()
        self.categoryName = newTracker.categoryName
    }
    
    init(from tracker: TrackerCoreData) {
        self.id = tracker.id ?? UUID()
        self.name = tracker.name ?? ""
        self.color = tracker.color ?? ""
        self.emoji = tracker.emoji ?? ""
        self.schedule = tracker.schedule ?? ""
        self.createdAt = tracker.createdAt ?? Date()
        self.categoryName = tracker.categoryName ?? ""
    }
}
