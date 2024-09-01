//
//  DataProvider.swift
//  Tracker
//
//  Created by Илья Лощилов on 30.08.2024.
//

import Foundation
import CoreData

protocol DataProviderDelegate: AnyObject {
    func didUpdate()
}

protocol DataProviderProtocol {
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at: IndexPath) -> TrackerCategoryCoreData?
    func addRecord(_ record: TrackerRecord)
    func deleteRecord(at indexPath: IndexPath)
}

// MARK: - DataProvider
final class DataProvider: NSObject {
    
    weak var delegate: DataProviderDelegate?
    
    private let context: NSManagedObjectContext
    private let dataStore: Storage
    
    init(_ dataStore: Storage, delegate: DataProviderDelegate) {
        self.delegate = delegate
        self.context = dataStore.context
        self.dataStore = dataStore
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {

        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: false)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
}

// MARK: - DataProviderProtocol
extension DataProvider: DataProviderProtocol {
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategoryCoreData? {
        fetchedResultsController.object(at: indexPath)
    }
    
    func addRecord(_ record: TrackerRecord) {
        
    }
    
    func deleteRecord(at indexPath: IndexPath) {
        
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension DataProvider: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?)
    {
        switch type {
        case .delete:
            break
        case .insert:
            break
        default:
            break
        }
    }
}
