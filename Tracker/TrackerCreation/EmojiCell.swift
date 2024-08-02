//
//  EmojiCell.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.07.2024.
//

import Foundation
import UIKit

final class EmojiCell: UICollectionViewCell {
    
    // MARK: - Constants

    static let identifier = "EmojiCell"
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public Properties
    
    override var isSelected: Bool {
        didSet {
            emojiLabel.backgroundColor = isSelected ? .ypGrey : .ypWhite
        }
    }
    
    // MARK: - Private Properties

    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Public Methods

    func setupCell(emoji: String) {
        emojiLabel.text = emoji
    }
    
    // MARK: - Private Methods
    
    private func setUp() {
        contentView.addSubview(emojiLabel)
        emojiLabel.layer.cornerRadius = 16
        emojiLabel.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 52),
            emojiLabel.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
