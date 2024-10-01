//
//  StatisticsManager.swift
//  Tracker
//
//  Created by Илья Лощилов on 25.09.2024.
//

import AppMetricaCore

enum Event: String {
    case open, close, click
}

enum Screen: String {
    case main, creation, category
}

enum Action: String {
    case addTrack = "add_track"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}

final class StatisticsManager {
    static let shared = StatisticsManager()

    private init() {}
    
    func integrateYandexMetrica() {
        guard let configuration = AppMetricaConfiguration(apiKey: "3122d1b8-4361-42a4-9d1e-e6ef630e0661") else { return }
        AppMetrica.activate(with: configuration)
    }
    
    func sendEvent(_ event: Event, screen: Screen, item: Action?) {
        var params: [AnyHashable: Any] = ["screen": screen.rawValue]
        if let item {
            params["item"] = item.rawValue
        }
        AppMetrica.reportEvent(name: event.rawValue, parameters: params)
    }
}
