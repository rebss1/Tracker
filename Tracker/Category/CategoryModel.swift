//
//  CategoryModel.swift
//  Tracker
//
//  Created by Илья Лощилов on 06.09.2024.
//

import Foundation

final class CategoryModel {
    
    private let storage = Storage.shared
    private let trackerManager = TrackerManager.shared
    
    var categories: [TrackerCategory] {
        storage.getCategories()
    }
    
    func createNewCategory(with categoryName: String) {
        storage.createСategory(with: categoryName)
    }
    
    func getCurrentCategoryName() -> String {
        trackerManager.newTracker.categoryName
    }
    
    func changeCategory(to categoryName: String) {
        trackerManager.changeCategory(categoryName: categoryName)
    }
}
