//
//  StatsCell.swift
//  Tracker
//
//  Created by Илья Лощилов on 25.09.2024.
//

import UIKit

final class StatsCell: UITableViewCell {
    
    // MARK: - Constants

    static let identifier = "StatsCell"
    
    // MARK: - Private Properties

    private var gradient = CAGradientLayer()
    private let gradientColors = [
        UIColor.gradientComponent1.cgColor,
        UIColor.gradientComponent2.cgColor,
        UIColor.gradientComponent3.cgColor
    ]
    
    // MARK: - UIViews

    private lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 7
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0))
    }
    
    // MARK: - Private Methods
    
    private func setupGradientView() {
        gradient.colors = gradientColors
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        contentView.layer.addSublayer(gradient)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    private func setUp() {
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(subTitleLabel)
        cellBackgroundView.addSubviews([containerStack])
        contentView.addSubviews([cellBackgroundView])
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            cellBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
            cellBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1),
            cellBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            
            containerStack.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 11),
            containerStack.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -11),
            containerStack.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 11),
            containerStack.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: -11)
        ])
    }
    
    // MARK: - Public Methods

    func setUpCell(with count: Int, message: String) {
        setupGradientView()
        setUp()
        titleLabel.text = "\(count)"
        subTitleLabel.text = message
    }
}
