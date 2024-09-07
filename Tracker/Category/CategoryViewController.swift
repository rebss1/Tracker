//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 06.09.2024.
//

import Foundation
import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - Constants

    static let reloadCollection = Notification.Name(rawValue: "reloadCollection")

    // MARK: - Private Properties
    
    private var viewModel: CategoryViewModel
    private var observer: NSObjectProtocol?
    private var categories: [TrackerCategory] = []
    
    private let stubView = StubView(emoji: "dizzy",
                                    text: "Habits and events can be combined by meaning")
    
    private lazy var createNewCategoryButton = Button(
        title: "Create new category",
        style: .normal,
        color: .ypBlack
    ) {
        let viewController = CategoryCreationViewController(viewModel: self.viewModel).wrapWithNavigationController()
        self.present(viewController, animated: true)
        
    }
    
    private lazy var doneButton = Button(
        title: "Done",
        style: .normal,
        color: .ypBlack
    ) {
        self.dismiss(animated: true)
        self.viewModel.didDoneButtonTapped()
    }
    
    private lazy var categoryTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Initializers

    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        viewModel.loadUpdatedCategories()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        addObserver()
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        viewModel.isEmptyCategoriesBinding = { [weak self] isEmpty in
            if isEmpty {
                self?.categoryTable.backgroundView = self?.stubView
            } else {
                self?.categoryTable.backgroundView = nil
            }
        }
        
        viewModel.categoriesBinding = { [weak self] categories in
            self?.categories = categories
        }
    }

    private func addObserver() {
        observer = NotificationCenter.default.addObserver(
            forName: CategoryViewController.reloadCollection,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.categoryTable.reloadData()
        }
    }
    
    private func setUp() {
        navigationItem.title = "Categories"
        view.backgroundColor = .ypWhite
        view.addSubviews([categoryTable, doneButton, createNewCategoryButton])
        
        NSLayoutConstraint.activate([
            categoryTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            createNewCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createNewCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createNewCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createNewCategoryButton.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -16),
        ])
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath: indexPath)
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath)
        guard let categoryCell = cell as? CategoryCell else { return UITableViewCell() }
        
        let category = categories[indexPath.row]
        let isFirstCell = indexPath.row == 0
        let isLastCell = indexPath.row == categories.count - 1
        
        categoryCell.setUpCell(with: category, isFirst: isFirstCell, isLast: isLastCell)
        
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 }
}
