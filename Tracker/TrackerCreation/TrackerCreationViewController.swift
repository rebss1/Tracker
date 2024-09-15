//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.07.2024.
//

import Foundation
import UIKit

final class TrackerCreationViewController: UIViewController {
    
    static let reloadCollection = Notification.Name(rawValue: "reloadCollection")
    
    private let trackerManager = TrackerManager.shared
    private var observer: NSObjectProtocol?
    private lazy var collectionWidth = collectionView.frame.width
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.frame,
                                              collectionViewLayout: layout)
        collectionView.register(CollectionHeader.self, forCellWithReuseIdentifier: CollectionHeader.identifier)
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.register(CollectionFooter.self, forCellWithReuseIdentifier: CollectionFooter.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .ypWhite
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        addObserver()
    }
    
    private func setUp() {
        navigationItem.title = NSLocalizedString("newtrackerCreationTitle", comment: "")
        view.backgroundColor = .ypWhite
        view.addSubviews([collectionView])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addObserver() {
        observer = NotificationCenter.default.addObserver(
            forName: TrackerCreationViewController.reloadCollection,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.collectionView.reloadSections(IndexSet(arrayLiteral: 0, 3 ))
        }
    }
}

extension TrackerCreationViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionItems.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionItems[section].data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionHeader.identifier, for: indexPath)
            guard let collectionHeader = cell as? CollectionHeader
            else { return UICollectionViewCell() }
            collectionHeader.setupCell()
            collectionHeader.delegate = self
            collectionHeader.isUserInteractionEnabled = true
            return collectionHeader
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath)
            let emoji = Constants.emojiList[indexPath.row]
            guard let emojiCell = cell as? EmojiCell
            else { return UICollectionViewCell() }
            emojiCell.setupCell(emoji: emoji)
            return emojiCell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath)
            guard let colorCell = cell as? ColorCell,
                  let color = UIColor(named: Constants.colorList[indexPath.row])
            else { return UICollectionViewCell() }
            colorCell.setupCell(color: color)
            return colorCell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionFooter.identifier, for: indexPath)
            guard let collectionFooter = cell as? CollectionFooter
            else { return UICollectionViewCell() }
            collectionFooter.setupCell()
            collectionFooter.delegate = self
            return collectionFooter
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            return UICollectionReusableView(frame: .zero)
        case 3:
            return UICollectionReusableView(frame: .zero)
        default:
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.identifier,
                for: indexPath
            ) as! SectionHeader
            sectionHeader.setUp(title: collectionItems[indexPath.section].title)
            return sectionHeader
        }
    }
}

extension TrackerCreationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let emoji = Constants.emojiList[indexPath.row]
            trackerManager.changeEmoji(emoji: emoji)
        case 2:
            let color = Constants.colorList[indexPath.row]
            trackerManager.changeColor(color: color)
        default:
            return
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            trackerManager.changeEmoji(emoji: nil)
        case 2:
            trackerManager.changeColor(color: nil)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?
            .filter({ $0.section == indexPath.section })
            .forEach({ collectionView.deselectItem(at: $0, animated: false) })
        return true
    }
}

extension TrackerCreationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let section = indexPath.section
        switch section {
        case 0:
            return CGSize(width: collectionWidth, 
                          height: headerHeight())
        case 1:
            return CGSize(width: 52, height: 52)
        case 2:
            return CGSize(width: 52, height: 52)
        case 3:
            return CGSize(width: collectionWidth, 
                          height: 60)
        default:
            return CGSize(width: 0, height: 0)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        switch section {
        case 0:
            return Insets.horizontalInset
        case 1:
            return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        case 2:
            return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        case 3:
            return UIEdgeInsets(top: 40, left: 20, bottom: 0, right: 20)
        default:
            return Insets.emptyInset
        }
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
        switch section {
            case 0:
                return .zero
            case 1:
                return CGSize(width: collectionWidth, height: 74)
            case 2:
                return CGSize(width: collectionWidth, height: 74)
            case 3:
                return .zero
            default:
                return .zero
        }
    }
    
    func headerHeight() -> CGFloat {
        var height: CGFloat = 75
        if trackerManager.error != nil {
            height += 22 + 8 + 32 + 24
        } else {
            height += 24 + 24
        }
        if trackerManager.isRegular {
            height += 150
        } else {
            height += 75
        }
        return height
    }
}

extension TrackerCreationViewController: CollectionFooterDelegate {
    func didTapCreateButton() {
        trackerManager.createTracker(category: trackerManager.newTracker.categoryName)
        let presentingViewController = self.presentingViewController
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}

extension TrackerCreationViewController: CollectionHeaderDelegate {
    func openSchedule() {
        let viewController = ScheduleViewController().wrapWithNavigationController()
        self.present(viewController, animated: true)
    }
    
    func openCategories() {
        let model = CategoryModel()
        let viewModel = CategoryViewModel(model: model)
        let viewController = CategoryViewController(viewModel: viewModel).wrapWithNavigationController()
        self.present(viewController, animated: true)
    }
}
