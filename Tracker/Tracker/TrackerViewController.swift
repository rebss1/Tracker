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
    static let resetDatePicker = Notification.Name(rawValue: "resetDatePicker")
    
    private var observer: NSObjectProtocol?
    private let trackerManager = TrackerManager.shared
    private let statsManager = StatisticsManager.shared
    //private var filteredTrackers: [TrackerCategory]?
    
    private let stubView = StubView(emoji: "dizzy",
                                    text: NSLocalizedString("emptyTrackersStubViewText", comment: ""))
    private lazy var collectionWidth = collectionView.frame.width
    //private lazy var searchBar = UISearchBar(frame: .zero)
    
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
    
    private lazy var filterButton = Button(title: NSLocalizedString("filters", comment: ""),
                                           style: .normal,
                                           color: .ypBlue
    ) {
        let viewController = FilterViewController().wrapWithNavigationController()
        self.present(viewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpDatePicker()
        setUpViews()
        addObserver()
        
        //filteredTrackers = trackerManager.filteredTrackers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statsManager.sendEvent(.open, screen: .main, item: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statsManager.sendEvent(.close, screen: .main, item: nil)
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
        view.addSubviews([collectionView, filterButton])
        
        filterButton.isHidden = trackerManager.filteredTrackers.count == 0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
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
        
        observer = NotificationCenter.default.addObserver(
            forName: TrackerViewController.resetDatePicker,
            object: nil,
            queue: .main
        ) { _ in
            datePicker.setDate(Date(), animated: true)
        }
    }
    
    @objc private func addTracker() {
        statsManager.sendEvent(.open, screen: .creation, item: .addTracker)
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
        statsManager.sendEvent(.click, screen: .main, item: .tracker)
        guard
            let indexPath = collectionView.indexPath(for: cell)
        else { return }
        let tracker = trackerManager.filteredTrackers[indexPath.section].trackers[indexPath.row]
        trackerManager.updateDaysCounter(id: tracker.id)
        statsManager.sendEvent(.click, screen: .main, item: .tracker)
    }
    
    func didTapPinAction(_ indexPath: IndexPath) {
        trackerManager.pinTracker(with: indexPath)
    }

    func didTapUnpinAction(_ indexPath: IndexPath) {
        trackerManager.unpinTracker(with: indexPath)
    }

    func didTapEditAction(_ indexPath: IndexPath) {
        let tracker = trackerManager.getTracker(by: indexPath)
        let categoryName = trackerManager.getCategory(by: indexPath).title
        trackerManager.reset(tracker, categoryName: categoryName)
        let viewController = TrackerCreationViewController().wrapWithNavigationController()
        self.present(viewController, animated: true)
        statsManager.sendEvent(.click, screen: .main, item: .edit)
    }

    func didTapDeleteAction(_ indexPath: IndexPath) {
        trackerManager.deleteTracker(with: indexPath)
        statsManager.sendEvent(.click, screen: .main, item: .delete)
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
        let trackerCategory = trackerManager.filteredTrackers[indexPath.section]
        let tracker = trackerCategory.trackers[indexPath.row]
        let count = trackerManager.getTrackerCount(trackerID: tracker.id)
        let isCompleted = trackerManager.isTrackerCompleteForSelectedDay(trackerUUID: tracker.id) >= 0
        let isPinned = tracker.categoryName == NSLocalizedString("pinned", comment: "")
        cell.setUpCell(tracker: tracker, count: count, isCompleted: isCompleted, isPinned: isPinned)
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

// MARK: - UICollectionViewDelegate

extension TrackerViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath)
        guard let trackerCell = cell as? TrackerCell else { return UIContextMenuConfiguration() }
        let tracker = trackerManager.getTracker(by: indexPath)
        let isPinned = tracker.categoryName == NSLocalizedString("pinned", comment: "")
        return trackerCell.configureContextMenu(indexPath, self, isPinned)
    }
}

//extension TrackerViewController: UISearchResultsUpdating {
//    
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
//            for trackerCategory in trackerManager.filteredTrackers {
//                for tracker in trackerCategory.trackers {
//                    if tracker.name.lowercased().contains(searchText.lowercased()) {
//                        filteredTrackers?.append(TrackerCategory(title: trackerCategory.title, trackers: [tracker]))
//                    }
//                }
//            }
//        } else {
//            filteredTrackers = trackerManager.filteredTrackers
//        }
//        collectionView.reloadData()
//    }
//}
