//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 06.07.2024.
//

import Foundation
import UIKit

final class ScheduleViewController: UIViewController {
    
    private let trackerManager = TrackerManager.shared
    
    private lazy var scheduleTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var doneButton = Button(
        title: NSLocalizedString("doneButtonTitle", comment: ""),
        style: .normal,
        color: .ypBlack
    ) {
        self.trackerManager.changeSchedule()
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func cellWasTapped(indexPath: IndexPath) {
        trackerManager.changeSelectedSchedule(indexPath: indexPath)
    }
    
    private func setUp() {
        navigationItem.title = NSLocalizedString("scheduleTitle", comment: "")
        view.backgroundColor = .ypWhite
        view.addSubviews([scheduleTable, doneButton])
        
        NSLayoutConstraint.activate([
            scheduleTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scheduleTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scheduleTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scheduleTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellWasTapped(indexPath: indexPath)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerManager.week.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.identifier, for: indexPath)
        guard let scheduleCell = cell as? ScheduleCell else { return UITableViewCell() }
        
        let isFirstCell = indexPath.row == 0
        let isLastCell = indexPath.row == trackerManager.week.count - 1
        
        scheduleCell.setupCell(schedule: trackerManager.week[indexPath.row],
                               isFirst: isFirstCell, isLast: isLastCell)
        
        scheduleCell.layer.cornerRadius = 16
        scheduleCell.clipsToBounds = true
        scheduleCell.delegate = self
        scheduleCell.layer.borderColor = UIColor.ypWhite.cgColor
        
        return scheduleCell
    }
}

extension ScheduleViewController: ScheduleCellDelegate {
    func didTapSwitch(_ cell: ScheduleCell) {
        guard let indexPath = scheduleTable.indexPath(for: cell) else { return }
        cellWasTapped(indexPath: indexPath)
    }
}
