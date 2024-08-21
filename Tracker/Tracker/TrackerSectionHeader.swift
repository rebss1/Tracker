//
//  TrackerSectionHeader.swift
//  Tracker
//
//  Created by Илья Лощилов on 28.07.2024.
//

import Foundation
import UIKit

final class TrackerSectionHeader: UICollectionReusableView {

    // MARK: - Constants

    static let identifier = "TrackerSectionHeader"

    // MARK: - UIViews

    private lazy var titleLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()

    // MARK: - Public Methods

    func setupSection(title: String) {
        titleLabel.text = title
        setUp()
    }
    
    // MARK: - Private Methods
    
    private func setUp() {
        addSubviews([titleLabel])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
