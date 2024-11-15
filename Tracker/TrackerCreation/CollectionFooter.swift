//
//  CollectionFooter.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.07.2024.
//

import Foundation
import UIKit

final class CollectionFooter: UICollectionViewCell {
    
    // MARK: - Constants

    static let identifier = "CollectionFooter"
    
    private let trackerManager = TrackerManager.shared
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public Properties

    weak var delegate: CollectionFooterDelegate?
    
    // MARK: - Private Properties
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private lazy var cancelButton = Button(
        title: NSLocalizedString("cancelButtonTitle", comment: ""),
        style: .flat,
        color: .ypRed
    ) {
        self.parentViewController?.dismiss(animated: true)
    }
    
    private lazy var createButton = Button(
        title: NSLocalizedString("creationButtonTitle", comment: ""),
        style: .normal,
        color: .ypBlack
    ) {
        self.delegate?.didTapCreateButton()
    }
    
    func setupCell() {
        createButton.isEnabled = trackerManager.canCreate
    }
    
    // MARK: - Private Functions

    private func setUp() {
        contentView.addSubviews([containerStack])
        containerStack.addArrangedSubview(cancelButton)
        containerStack.addArrangedSubview(createButton)
        
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
