//
//  TypeOfTrackerViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 29.06.2024.
//

import Foundation
import UIKit

final class TypeOfTrackerViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let trackerManager = TrackerManager.shared
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        return stack
    }()
    
    private lazy var regularDoButton = Button(
        title: "Habit",
        style: .normal,
        color: .ypBlack
    ) {
        self.trackerManager.reset()
        self.trackerManager.changeFrequency(frequency: .regular)
        let viewController = TrackerCreationViewController().wrapWithNavigationController()
        self.present(viewController, animated: true)
    }
    
    private lazy var notRegularDoButton = Button(
        title: "Irregular action",
        style: .normal,
        color: .ypBlack
    ) {
        self.trackerManager.reset()
        self.trackerManager.changeFrequency(frequency: .single)
        let viewController = TrackerCreationViewController().wrapWithNavigationController()
        self.present(viewController, animated: true)
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - Configure
    
    private func setUp() {
        view.backgroundColor = .ypWhite
        view.addSubview(containerStack)
        containerStack.addArrangedSubview(regularDoButton)
        containerStack.addArrangedSubview(notRegularDoButton)
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            containerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            containerStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            containerStack.heightAnchor.constraint(equalToConstant: 136)
        ])
    }
}
