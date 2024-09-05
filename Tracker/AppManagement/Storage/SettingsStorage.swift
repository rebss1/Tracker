//
//  SettingsStorage.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.09.2024.
//

import Foundation

final class SettingsStorage {
    
    public static let shared = SettingsStorage()
    
    let defaults = UserDefaults.standard
    
    private init() {}

    var isOnbordingWasShown: Bool {
        defaults.bool(forKey: Constants.onboardingDefaultsKey)
    }
    
    func setOnboardingShown() {
        defaults.set(true, forKey: Constants.onboardingDefaultsKey)
    }
}
