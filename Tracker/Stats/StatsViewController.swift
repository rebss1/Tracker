//
//  StatsViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 27.06.2024.
//

import Foundation
import UIKit

final class StatsViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Constants

    static let reloadCollection = Notification.Name(rawValue: "reloadCollection")

    // MARK: - Private Properties
    
    private let trackerManager = TrackerManager.shared

    // MARK: - UIViews

    private let stubView = StubView(emoji: "sadEmoji",
                                    text: NSLocalizedString("emptyStatsStubViewText", comment: ""))
    
    private lazy var statsTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StatsCell.self, forCellReuseIdentifier: StatsCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.backgroundView = stubView
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Private Methods
    
    private func setupNavBar() {
        navigationItem.title = NSLocalizedString("statsTitle", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setUp() {
        view.backgroundColor = .ypWhite
        view.addSubviews([statsTable])
        
        NSLayoutConstraint.activate([
            statsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            statsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension StatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let trackersCount = trackerManager.getAllTrackersCount()
        if trackersCount > 0 {
            stubView.isHidden = true
            return 2
        } else {
            stubView.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatsCell.identifier, for: indexPath) as? StatsCell else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            let trackersCount = trackerManager.getAllTrackersCount()
            cell.setUpCell(with: trackersCount, message: NSLocalizedString("createdTrackersStats", comment: ""))
        case 1:
            let doneTrackersCount = trackerManager.getAllRecordsCount()
            cell.setUpCell(with: doneTrackersCount, message: NSLocalizedString("completedTrackersStats", comment: ""))
        default:
            cell.setUpCell(with: 0, message: "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 102 }
}
