//
//  Constants.swift
//  Tracker
//
//  Created by Илья Лощилов on 29.06.2024.
//

import Foundation
import UIKit

struct Insets {
    static let horizontalInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    static let emptyInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    static let fullInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
}

struct Config {
    static let trackerCellHeight: CGFloat = 148
    static let trackerSpaceBetweenCells: CGFloat = 8
}

let emojiList = [
    "🙂", "😻", "🌺", "🐶", "❤️", "😱",
    "😇", "😡", "🥶", "🤔", "🙌", "🍔",
    "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
]

let colorList = [
    "cs1", "cs2", "cs3", "cs4", "cs5", "cs6", "cs7", "cs8", "cs9", "cs10", "cs11", "cs12", "cs13", "cs14", "cs15", "cs16", "cs17", "cs18"
]


let trackersMockData = [
    TrackerCategory(
        title: "Main",
        trackers: [
            Tracker(
                id: UUID(),
                type: .regular,
                name: "Work days",
                color: "cs1",
                emoji: "🐶",
                schedule: "Work days"
            ),
            Tracker(
                id: UUID(),
                type: .regular,
                name: "Every day",
                color: "cs3",
                emoji: "🐶",
                schedule: "Every day"
            ),
            Tracker(
                id: UUID(),
                type: .regular,
                name: "Mon, Fri",
                color: "cs7",
                emoji: "🐶",
                schedule: "Mon, Fri"
            )
        ]
    ),
]
