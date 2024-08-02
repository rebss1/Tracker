//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Илья Лощилов on 28.06.2024.
//

import Foundation

protocol TrackerCellDelegate: AnyObject {
    func didTapPlusButton(_ cell: TrackerCell)
}
