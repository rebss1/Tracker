//
//  Store.swift
//  Tracker
//
//  Created by Илья Лощилов on 22.08.2024.
//

import Foundation
import CoreData

protocol StorageProtocol {
    var context: NSManagedObjectContext { get }
}

final class Storage: StorageProtocol {
    
    public static let shared = Storage()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Initialization

    private init() {}
    
    // MARK: - Core Data Saving support

    private func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    //MARK: - Create Methods
    
    func createTracker(with tracker: Tracker, categoryName: String) {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = tracker.color
        trackerEntity.schedule = tracker.schedule
        
        let categoryEntity = createСategory(with: categoryName)
        categoryEntity.addToTrackers(trackerEntity)
        
        saveContext()
    }
    
    func createСategory(with categoryName: String) -> TrackerCategoryCoreData {
        if let existedCategory = getCategoryCoreData(by: categoryName) {
            return existedCategory
        }
        let categoryEntity = TrackerCategoryCoreData(context: context)
        categoryEntity.title = categoryName
        
        saveContext()
        
        return categoryEntity
    }
    
    func makeRecord(with trackerID: UUID, at date: Date) {
        let records = getRecordsCoreData(of: trackerID)
        let index = records.firstIndex { Calendar.current.isDate($0.date ?? Date(), equalTo: date, toGranularity: .day) } ?? -1
        
        if index >= 0 {
            context.delete(records[index])
        } else {
            let recordEntity = TrackerRecordCoreData(context: context)
            recordEntity.id = trackerID
            recordEntity.date = date
        }
        
        saveContext()
    }
    
    //MARK: - Get Methods
    
    private func getTracker(by id: UUID) -> TrackerCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            guard let tracker = try context.fetch(fetchRequest).first else {
                return nil
            }
            return tracker
        }
        catch let error as NSError {
            print(error.userInfo)
            return nil
        }
    }

    private func getCategoryCoreData(by name: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", name)
        do {
            guard let category = try context.fetch(fetchRequest).first else {
                return nil
            }
            return category
        }
        catch let error as NSError {
            print(error.userInfo)
            return nil
        }
    }
    
    private func getRecordsCoreData(of trackerID: UUID) -> [TrackerRecordCoreData] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
        do {
            let records = try context.fetch(fetchRequest)
            return records
        }
        catch let error as NSError {
            print(error.userInfo)
            return []
        }
    }
    
    func getRecords(of trackerID: UUID) -> [TrackerRecord] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
        do {
            let records = try context.fetch(fetchRequest)
            return records.map { TrackerRecord(from: $0)}
        }
        catch let error as NSError {
            print(error.userInfo)
            return []
        }
    }
    
    func getCategories() -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        do {
            let categoryEntities = try context.fetch(fetchRequest)
            return categoryEntities.map {
                let trackers = $0.trackers?
                    .map { Tracker(from: $0 as! TrackerCoreData) }
                    .sorted { $0.createdAt < $1.createdAt }
                return TrackerCategory(title: $0.title ?? "",
                                       trackers: trackers ?? [])
            }
        } catch let error as NSError {
            print(error.userInfo)
            return []
        }
    }
}
