//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Илья Лощилов on 28.06.2024.
//

import Foundation

struct TrackerRecord {
    let id: UUID
    let date: [Date]
    
    init(id: UUID, date: [Date]) {
        self.id = id
        self.date = date
    }
}
