//
//  CategoryCell.swift
//  Tracker
//
//  Created by Илья Лощилов on 06.09.2024.
//

import Foundation
import UIKit

final class CategoryCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let identifier = "CategoryCell"
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var checkmarkImage: UIImageView = {
        let image = UIImage(systemName: "checkmark")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        checkmarkImage.isHidden = !selected
    }
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private Methods
    
    private func setUp() {
        addSubviews([titleLabel, checkmarkImage])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75),

            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: checkmarkImage.leadingAnchor),

            checkmarkImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkmarkImage.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImage.heightAnchor.constraint(equalToConstant: 24),
            checkmarkImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    func setUpCell(with category: TrackerCategory, isFirst: Bool, isLast: Bool) {
        titleLabel.text = category.title
        
        backgroundColor = .ypLightGrey
        clipsToBounds = true
        layer.cornerRadius = 16
        
        if isFirst {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLast {
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            layer.maskedCorners = []
        }
    }
}
