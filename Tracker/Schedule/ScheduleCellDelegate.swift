//
//  ScheduleCellDelegate.swift
//  Tracker
//
//  Created by Илья Лощилов on 06.07.2024.
//

import Foundation
import UIKit

protocol ScheduleCellDelegate: AnyObject {
    func didTapSwitch(_ cell: ScheduleCell)
}
