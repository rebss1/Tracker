//
//  TrackerCell.swift
//  Tracker
//
//  Created by Илья Лощилов on 28.06.2024.
//

import Foundation
import UIKit

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Constants

    static let identifier = "TrackerCell"
    
    // MARK: - Public Properties

    weak var delegate: TrackerCellDelegate?
    
    // MARK: - UIViews

    private lazy var cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var emojiBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite30
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var emoji: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(),
                                           target: self,
                                           action: #selector(didTapPlusButton))
        return button
    }()
    
    private lazy var quantityManagementView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Public Methods
    
    func setUpCell(tracker: Tracker, count: Int, isCompleted: Bool) {
        cellBackgroundView.backgroundColor = UIColor(named: tracker.color)
        emoji.text = tracker.emoji
        textLabel.text = tracker.name
        let format = NSLocalizedString("declension_of_word_day", comment: "")
        let text = String.localizedStringWithFormat(format, count)
        quantityLabel.text = text
        plusButton.tintColor = UIColor(named: tracker.color)
        plusButton.layer.opacity = isCompleted ? 0.3 : 1
        plusButton.setImage(UIImage(named: isCompleted ? "done" : "plus"),
                            for: .normal)
        setUp()
    }

    // MARK: - Private Methods

    @objc private func didTapPlusButton() {
        delegate?.didTapPlusButton(self)
    }
    
    private func setUp() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        contentView.addSubviews([cellBackgroundView, quantityManagementView])
        cellBackgroundView.addSubviews([emojiBackground, textLabel])
        emojiBackground.addSubview(emoji)
        quantityManagementView.addSubviews([quantityLabel, plusButton])
        
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackgroundView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        quantityManagementView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quantityManagementView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            quantityManagementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quantityManagementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quantityManagementView.topAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor)
        ])
        
        emojiBackground.translatesAutoresizingMaskIntoConstraints = false
        emojiBackground.layer.cornerRadius = 12
        NSLayoutConstraint.activate([
            emojiBackground.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 12),
            emojiBackground.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 12),
            emojiBackground.heightAnchor.constraint(equalToConstant: 24),
            emojiBackground.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        emoji.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emoji.centerYAnchor.constraint(equalTo: emojiBackground.centerYAnchor),
            emoji.centerXAnchor.constraint(equalTo: emojiBackground.centerXAnchor)
        ])
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: -12),
            textLabel.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -12),
        ])
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.topAnchor.constraint(equalTo: quantityManagementView.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: quantityManagementView.trailingAnchor, constant: -12)
        ])
        
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quantityLabel.topAnchor.constraint(equalTo: quantityManagementView.topAnchor, constant: 16),
            quantityLabel.leadingAnchor.constraint(equalTo: quantityManagementView.leadingAnchor, constant: 12)
        ])
    }
}
