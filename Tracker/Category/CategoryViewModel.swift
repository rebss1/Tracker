//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Илья Лощилов on 06.09.2024.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    
    var categoriesBinding: Binding<[TrackerCategory]>?
    var isEmptyCategoriesBinding: Binding<Bool>?
    var selectedCategoryName: Binding<String>?
    
    private let model: CategoryModel
    private let trackerManager = TrackerManager.shared
    
    init(model: CategoryModel) {
        self.model = model
    }
    
    func loadUpdatedCategories() {
        categoriesBinding?(model.categories)
        isEmptyCategoriesBinding?(model.categories.isEmpty)
        selectedCategoryName?(model.getCurrentCategoryName())
        trackerManager.updateCategories()
    }
    
    func createNewCategory(with categoryName: String) {
        model.createNewCategory(with: categoryName)
        loadUpdatedCategories()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let categoryName = model.categories[indexPath.row].title
        model.changeCategory(to: categoryName)
        selectedCategoryName?(model.getCurrentCategoryName())
        trackerManager.updateCategories()
    }
    
    func didDoneButtonTapped() {
        trackerManager.updateCreation()
    }
}
