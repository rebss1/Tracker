//
//  RootViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 13.06.2024.
//

import UIKit

final class RootViewController: UIViewController {
    
    private let settingsStorage = SettingsStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectViewController()
    }
    
    private func selectViewController() {
        let rootViewController: UIViewController
        if settingsStorage.isOnbordingWasShown {
            rootViewController = TabBarViewController()
        } else {
            var onboardingViewController = OnboardingViewController()
            onboardingViewController.tapHandler = switchToApp
            rootViewController = onboardingViewController
        }
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = rootViewController
    }
    
    func switchToApp() {
        settingsStorage.setOnboardingShown()
        let rootController = TabBarViewController()
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = rootController
    }
}


