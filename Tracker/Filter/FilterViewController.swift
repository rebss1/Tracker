//
//  FilterViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 25.09.2024.
//

import UIKit

final class FilterViewController: UIViewController {
    
    // MARK: - Constants

    static let reloadCollection = Notification.Name(rawValue: "reloadCollection")

    // MARK: - Private Properties
    
    private let trackerManager = TrackerManager.shared
    private var observer: NSObjectProtocol?
    
    private lazy var filterTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        setUp()
    }
    
    // MARK: - Private Methods
    
    private func addObserver() {
        observer = NotificationCenter.default.addObserver(
            forName: FilterViewController.reloadCollection,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.filterTable.reloadData()
        }
    }
    
    private func setUp() {
        view.backgroundColor = .ypWhite
        navigationItem.title = NSLocalizedString("filters", comment: "")
        view.addSubviews([filterTable])
        
        NSLayoutConstraint.activate([
            filterTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filterTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            filterTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        trackerManager.addFilter(indexPath: indexPath)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerManager.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.identifier, for: indexPath) as? FilterCell else { return UITableViewCell() }
        let filter = trackerManager.filters[indexPath.row]
        let title = NSLocalizedString(filter.rawValue, comment: "")
        
        let isFirstCell = indexPath.row == 0
        let isLastCell = indexPath.row == trackerManager.filters.count - 1
        let isSelected = trackerManager.filter == filter
        
        cell.setUpCell(with: title, isFirst: isFirstCell, isLast: isLastCell, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 }
}
