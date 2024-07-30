//
//  SectionHeader.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.07.2024.
//

import Foundation
import UIKit

final class SectionHeader: UICollectionViewCell {
    
    // MARK: - Constants

    static let identifier = "SectionHeader"
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setUp(title: String) {
        titleLabel.text = title
        setUp()
    }
    
    // MARK: - Private Functions

    private func setUp() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
