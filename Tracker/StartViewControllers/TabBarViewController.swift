//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 27.06.2024.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewControllers()
    }
    
    private func setUpViewControllers() {
        let trackerViewController = TrackerViewController().wrapWithNavigationController()
        let statsViewController = StatsViewController().wrapWithNavigationController()
        
        trackerViewController.tabBarItem = UITabBarItem(title: "Trackers",
                                                        image: UIImage(systemName: "record.circle.fill"), 
                                                        selectedImage: UIImage(systemName: "record.circle.fill"))
        statsViewController.tabBarItem = UITabBarItem(title: "Statistic",
                                                      image: UIImage(systemName: "hare.fill"),
                                                      selectedImage: UIImage(systemName: "hare.fill"))
        tabBar.tintColor = .ypBlue
        viewControllers = [trackerViewController, statsViewController]
    }
}
