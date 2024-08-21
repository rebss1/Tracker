//
//  CollectionItems.swift
//  Tracker
//
//  Created by Илья Лощилов on 07.07.2024.
//

import Foundation

struct Item {
    let title: String
    let data: [String]
}

let collectionItems = [
    Item(title: "", data: [""]),
    Item(title: "Emoji", data: Constants.emojiList),
    Item(title: "Color", data: Constants.colorList),
    Item(title: "", data: [""])
]
