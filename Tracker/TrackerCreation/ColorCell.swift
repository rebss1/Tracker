//
//  ColorCell.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.07.2024.
//

import Foundation
import UIKit

final class ColorCell: UICollectionViewCell {
    
    // MARK: - Constants

    static let identifier = "ColorCell"
    
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
            contentView.layer.borderWidth = 3
            contentView.layer.borderColor = isSelected ?
            colorView.backgroundColor?.withAlphaComponent(0.3).cgColor : UIColor.ypWhite.cgColor
            contentView.layer.cornerRadius = 16
            contentView.layer.masksToBounds = true
        }
    }
    
    // MARK: - Private Properties

    private lazy var colorView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Public Methods

    func setupCell(color: UIColor) {
        colorView.backgroundColor = color
    }
    
    // MARK: - Public Methods

    private func setUp() {
        contentView.addSubviews([colorView])
        colorView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: 52),
            contentView.heightAnchor.constraint(equalToConstant: 52),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
