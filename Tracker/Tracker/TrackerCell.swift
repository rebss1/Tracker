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
    
    private lazy var pinImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pin"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Public Methods
    
    func setUpCell(tracker: Tracker, count: Int, isCompleted: Bool, isPinned: Bool) {
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
        pinImageView.isHidden = !isPinned
        setUp()
    }
    
    // MARK: - Public Methods
    
    func configureContextMenu(
        _ indexPath: IndexPath,
        _ delegate: TrackerCellDelegate,
        _ isPinned: Bool
    ) -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            let pin = self.makeAction(NSLocalizedString("contextActionPin", comment: ""), false) { _ in
                delegate.didTapPinAction(indexPath)
            }
            let unpin = self.makeAction(NSLocalizedString("contextActionUnpin", comment: ""), false) {  _ in
                delegate.didTapUnpinAction(indexPath)
            }
            let edit = self.makeAction(NSLocalizedString("contextActionEdit", comment: ""), false) { _ in
                delegate.didTapEditAction(indexPath)
            }
            let delete = self.makeAction(NSLocalizedString("contextActionDelete", comment: ""), true) { _ in
                delegate.didTapDeleteAction(indexPath)
            }
            return UIMenu(
                title: "",
                image: nil,
                identifier: nil,
                options: UIMenu.Options.displayInline,
                children: [isPinned ? unpin : pin, edit, delete]
            )
        }
        return context
    }

    func makeAction(_ title: String, _ isDestructive: Bool, _ handler: @escaping UIActionHandler) -> UIAction {
        UIAction(
            title: title,
            image: nil,
            identifier: nil,
            discoverabilityTitle: nil,
            attributes: isDestructive ? .destructive : [],
            state: .off,
            handler: handler
        )
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
        cellBackgroundView.addSubviews([emojiBackground, textLabel, pinImageView])
        emojiBackground.addSubviews([emoji])
        quantityManagementView.addSubviews([quantityLabel, plusButton])
        
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackgroundView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            quantityManagementView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            quantityManagementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quantityManagementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quantityManagementView.topAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor)
        ])
        
        emojiBackground.layer.cornerRadius = 12
        NSLayoutConstraint.activate([
            emojiBackground.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 12),
            emojiBackground.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 12),
            emojiBackground.heightAnchor.constraint(equalToConstant: 24),
            emojiBackground.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            emoji.centerYAnchor.constraint(equalTo: emojiBackground.centerYAnchor),
            emoji.centerXAnchor.constraint(equalTo: emojiBackground.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: -12),
            textLabel.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.topAnchor.constraint(equalTo: quantityManagementView.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: quantityManagementView.trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            quantityLabel.topAnchor.constraint(equalTo: quantityManagementView.topAnchor, constant: 16),
            quantityLabel.leadingAnchor.constraint(equalTo: quantityManagementView.leadingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            pinImageView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 12),
            pinImageView.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -4),
            pinImageView.widthAnchor.constraint(equalToConstant: 24),
            pinImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
