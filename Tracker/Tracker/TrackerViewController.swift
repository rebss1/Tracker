//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 27.06.2024.
//

import Foundation
import UIKit

final class TrackerViewController: UIViewController {

    static let reloadCollection = Notification.Name(rawValue: "reloadTrackerCollection")
    private var observer: NSObjectProtocol?
    private let trackerManager = TrackerManager.shared
    
    private let stubView = StubView(emoji: "dizzy",
                                    text: NSLocalizedString("emptyTrackersStubViewText", comment: ""))
    private lazy var collectionWidth = collectionView.frame.width
    private lazy var searchBar = UISearchBar(frame: .zero)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.frame,
                                              collectionViewLayout: layout)
        collectionView.register(TrackerSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerSectionHeader.identifier)
        collectionView.register(TrackerCell.self,
                                forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .ypWhite
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpDatePicker()
        setUpViews()
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addObserver() {
        observer = NotificationCenter.default.addObserver(
            forName: TrackerViewController.reloadCollection,
            object: nil,
            queue: .main
        ) {
            [weak self] _ in self?.collectionView.reloadData()
        }
    }
    
    private func setUpViews() {
        view.backgroundColor = .ypWhite
        view.addSubviews([collectionView])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpNavigationBar() {
        view.backgroundColor = .ypWhite
        let add = UIBarButtonItem(barButtonSystemItem: .add,
                                  target: self,
                                  action: #selector(addTracker))
        add.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = add
        navigationItem.title = NSLocalizedString("trackersTitle", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = UISearchController(searchResultsController: nil)
    }
    
    private func setUpDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, 
                             action: #selector(datePickerValueChanged(_:)),
                             for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc private func addTracker() {
        present(TypeOfTrackerViewController().wrapWithNavigationController(), animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        trackerManager.changeSelectedDay(selectedDay: selectedDate)
    }
}

// MARK: - TrackerCellDelegate

extension TrackerViewController: TrackerCellDelegate {
    func didTapPlusButton(_ cell: TrackerCell) {
        guard
            let indexPath = collectionView.indexPath(for: cell)
        else { return }
        let tracker = trackerManager.filteredTrackers[indexPath.section].trackers[indexPath.row]
        trackerManager.updateDaysCounter(id: tracker.id)
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if trackerManager.filteredTrackers.isEmpty {
            collectionView.backgroundView = stubView
        } else {
            collectionView.backgroundView = nil
        }
        return trackerManager.filteredTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerManager.filteredTrackers[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell
        else { return UICollectionViewCell() }
        cell.delegate = self
        let tracker = trackerManager.filteredTrackers[indexPath.section].trackers[indexPath.row]
        let count = trackerManager.getTrackerCount(trackerID: tracker.id)
        let isCompleted = trackerManager.isTrackerCompleteForSelectedDay(trackerUUID: tracker.id) >= 0
        cell.setUpCell(tracker: tracker, count: count, isCompleted: isCompleted)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            let sectionTitle = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerSectionHeader.identifier,
            for: indexPath
            ) as? TrackerSectionHeader
        else {
            return UICollectionReusableView()
        }
        sectionTitle.setupSection(title: trackerManager.filteredTrackers[indexPath.section].title)
        return sectionTitle
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellWidth = (collectionWidth - Insets.horizontalInset.left - Insets.horizontalInset.right - Config.trackerSpaceBetweenCells) / 2
        return CGSize(width: cellWidth, height: Config.trackerCellHeight)   
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        Insets.horizontalInset
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat { 0 }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat { 0 }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionWidth, height: 52)
    }
}
