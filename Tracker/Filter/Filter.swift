//
//  Filter.swift
//  Tracker
//
//  Created by Илья Лощилов on 25.09.2024.
//

enum Filter: String, CaseIterable {
    case all = "allFilters"
    case today = "todayFilters"
    case finished = "finishedFilters"
    case unfinished = "unfinishedFilters"
}
