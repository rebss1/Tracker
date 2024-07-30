//
//  RootViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 13.06.2024.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        switchToTabBarController()
    }
    private func switchToTabBarController() {
        let rootController = TabBarViewController()
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = rootController
    }
}

