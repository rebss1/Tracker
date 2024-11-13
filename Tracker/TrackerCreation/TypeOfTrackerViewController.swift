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
        title: NSLocalizedString("trackerRegularType", comment: ""),
        style: .normal,
        color: .ypBlack
    ) {
        self.trackerManager.reset(nil, categoryName: "")
        self.trackerManager.changeFrequency(frequency: .regular)
        let viewController = TrackerCreationViewController().wrapWithNavigationController()
        self.present(viewController, animated: true)
    }
    
    private lazy var notRegularDoButton = Button(
        title: NSLocalizedString("trackerSingleType", comment: ""),
        style: .normal,
        color: .ypBlack
    ) {
        self.trackerManager.reset(nil, categoryName: "")
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
        navigationItem.title = NSLocalizedString("trackerTypeTitle", comment: "")
        view.backgroundColor = .ypWhite
        view.addSubviews([containerStack])
        containerStack.addArrangedSubview(regularDoButton)
        containerStack.addArrangedSubview(notRegularDoButton)
        
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            containerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            containerStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            containerStack.heightAnchor.constraint(equalToConstant: 136)
        ])
    }
}
