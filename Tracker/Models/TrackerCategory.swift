//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Илья Лощилов on 28.06.2024.
//

import Foundation

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
    
    init(title: String, trackers: [Tracker]) {
        self.title = title
        self.trackers = trackers
    }
    
    init(from category: TrackerCategoryCoreData) {
        self.title = category.title ?? ""
        self.trackers = category.trackers?.allObjects as? [Tracker] ?? []
    }
}
