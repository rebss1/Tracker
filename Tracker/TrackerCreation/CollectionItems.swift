//
//  CollectionItems.swift
//  Tracker
//
//  Created by Илья Лощилов on 07.07.2024.
//

import Foundation

struct Item {
    var title: String
    var data: [String]
}

let collectionItems = [
    Item(title: "", data: [""]),
    Item(title: "Emoji", data: emojiList),
    Item(title: "Color", data: colorList),
    Item(title: "", data: [""])
]
