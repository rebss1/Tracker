//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.09.2024.
//

import Foundation
import UIKit

final class OnboardingViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    var tapHandler: (() -> Void)?

    private var pageExamples: [PageExamples] = PageExamples.allCases
    
    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]? = nil
    ) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        let firstViewController = PageViewController(with: pageExamples[0], tapHandler)
        setViewControllers([firstViewController], direction: .forward, animated: true)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentViewController = viewController as? PageViewController else {
            return nil
        }
        
        var index = currentViewController.pageExample.rawValue
        if index == 0 {
            return nil
        }
        index -= 1
        
        return PageViewController(with: pageExamples[index], tapHandler)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentViewController = viewController as? PageViewController else {
            return nil
        }
        
        var index = currentViewController.pageExample.rawValue
        if index >= self.pageExamples.count - 1 {
            return nil
        }
        index += 1
        
        return PageViewController(with: pageExamples[index], tapHandler)
    }
}
