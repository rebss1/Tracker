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
}
