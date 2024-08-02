//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Илья Лощилов on 06.07.2024.
//

import Foundation
import UIKit

final class ScheduleCell: UITableViewCell {
    
    // MARK: - Constants

    static let identifier = "ScheduleCell"
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public Properties

    weak var delegate: ScheduleCellDelegate?
    
    // MARK: - UIViews

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.onTintColor = .ypBlue
        switcher.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
        return switcher
    }()
    
    // MARK: - Public Methods

    func setupCell(schedule: DayOfWeekSwitch, isFirst: Bool, isLast: Bool) {
        label.text = schedule.dayOfWeek.fullName
        switcher.isOn = schedule.isEnabled

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
    
    // MARK: - Private Methods
    
    @objc private func valueDidChange() {
        delegate?.didTapSwitch(self)
    }
    
    private func setUp() {
        contentView.addSubview(label)
        contentView.addSubview(switcher)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: switcher.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            switcher.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switcher.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
