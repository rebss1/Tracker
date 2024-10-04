//
//  TrackerManager.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.07.2024.
//

import Foundation

final class TrackerManager {
    static let shared = TrackerManager()
    
    // MARK: - Private Properties
    
    private let storage = Storage.shared
    private(set) var selectedDay: Date = Date()
    private(set) var week: [DayOfWeekSwitch]
    private(set) var error: String?
    private(set) var newTracker: NewTracker
    private(set) var filters: [Filter] = Filter.allCases
    private(set) var filter: Filter = Filter.all
    private let defaultWeek = DayOfWeek.allCases.map { DayOfWeekSwitch(dayOfWeek: $0, isEnabled: false) }
    private let defaultNewTracker = NewTracker(frequency: .regular, name: "", color: "", emoji: "", schedule: "", categoryName: "", createdAt: Date())
    
    private init() {
        self.week = defaultWeek
        self.newTracker = defaultNewTracker
    }
    
    var isRegular: Bool { newTracker.frequency == .regular }
    
    var canCreate: Bool {
        !newTracker.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
        && !newTracker.emoji.isEmpty
        && !newTracker.color.isEmpty
    }
    
    var trackers: [TrackerCategory] {
        var pinnedTrackers: [Tracker] = []
        let pinnedCategoryName = NSLocalizedString("pinned", comment: "")
        var categories = storage.getCategories().map {
            TrackerCategory(
                title: $0.title,
                trackers: $0.trackers
                    .filter {
                        if $0.categoryName == pinnedCategoryName {
                            pinnedTrackers.append($0)
                            return false
                        }
                        return true
                    }
            )
        }
        let pinnedCategory = TrackerCategory(title: pinnedCategoryName, trackers: pinnedTrackers)
        categories.insert(pinnedCategory, at: 0)
        return categories
    }
    
    var filteredTrackers: [TrackerCategory] {
        let categories = trackers.map {
            TrackerCategory(title: $0.title,
                            trackers: $0.trackers
                .filter {
                    if $0.schedule.isEmpty {
                        return true
                    }
                    let schedule = DayOfWeek.stringToSchedule(scheduleString: $0.schedule).map { String(describing: $0.dayOfWeek)}
                    let selectedDayOfWeek = selectedDay.dateToString()
                    return schedule.contains(selectedDayOfWeek)
                }.filter {
                    switch filter {
                    case .all:
                        return true
                    case .today:
                        return true
                    case .finished:
                        return isTrackerCompleteForSelectedDay(trackerUUID: $0.id)
                    case .unfinished:
                        return !isTrackerCompleteForSelectedDay(trackerUUID: $0.id)
                    }
                })
        } .filter { !$0.trackers.isEmpty }
        return categories
    }
    
    // MARK: - Trackers list methods
    
    func changeSelectedDay(selectedDay: Date) {
        self.selectedDay = selectedDay
        updateTrackers()
    }
    
    func updateDaysCounter(id: UUID) {
        storage.makeRecord(with: id, at: selectedDay)
        updateTrackers()
    }
    
    func isTrackerCompleteForSelectedDay(trackerUUID: UUID) -> Bool {
        let records = storage.getRecords(of: trackerUUID)
        return records.first { Calendar.current.isDate($0.date, equalTo: selectedDay, toGranularity: .day) } != nil
    }
    
    // MARK: - Creation methods
    
    func updateTrackers() {
        NotificationCenter.default.post(name: TrackerViewController.reloadCollection, object: self)
    }
    
    func updateCreation() {
        NotificationCenter.default.post(name: TrackerCreationViewController.reloadCollection, object: self)
    }
    
    func resetDatePicker() {
        NotificationCenter.default.post(name: TrackerViewController.resetDatePicker, object: self)
    }
    
    func updateCategories() {
        NotificationCenter.default.post(name: CategoryViewController.reloadCollection, object: self)
    }
    
    func updateFilters() {
        NotificationCenter.default.post(name: FilterViewController.reloadCollection, object: self)
    }
    
    func createTracker(category: String) {
        let tracker = Tracker(newTracker)
        storage.createTracker(with: tracker, categoryName: category)
        updateTrackers()
    }
    
    func changeColor(color: String?) {
        self.newTracker.color = color ?? ""
        updateCreation()
    }
    
    func changeEmoji(emoji: String?) {
        self.newTracker.emoji = emoji ?? ""
        updateCreation()
    }
    
    func changeName(name: String?) {
        self.newTracker.name = name ?? ""
        updateCreation()
    }
    
    func changeCategory(categoryName: String?) {
        self.newTracker.categoryName = categoryName ?? ""
    }
    
    func changeSchedule() {
        let schedule = DayOfWeek.scheduleToString(schedule: week)
        self.newTracker.schedule = schedule
        updateCreation()
    }
    
    func changeSelectedSchedule(indexPath: IndexPath) {
        let day = week[indexPath.row]
        week[indexPath.row].isEnabled = !day.isEnabled
        updateCreation()
    }
    
    func changeFrequency(frequency: TrackerFrequency) {
        self.newTracker.frequency = frequency
        updateCreation()
    }
    
    func getTrackerCount(trackerID: UUID) -> Int {
        storage.getRecords(of: trackerID).count
    }
    
    func getAllTrackersCount() -> Int {
        storage.getAllTrackers().count
    }
    
    func getAllRecordsCount() -> Int {
        storage.getAllRecords().count
    }
    
    func getTracker(by indexPath: IndexPath) -> Tracker {
        filteredTrackers[indexPath.section].trackers[indexPath.row]
    }

    func getCategory(by indexPath: IndexPath) -> TrackerCategory {
        storage.getCategories()[indexPath.section]
    }
    
    func pinTracker(with indexPath: IndexPath) {
        let tracker = getTracker(by: indexPath)
        storage.pinTracker(with: tracker.id)
        updateTrackers()
    }

    func unpinTracker(with indexPath: IndexPath) {
        let tracker = getTracker(by: indexPath)
        storage.unpinTracker(with: tracker.id)
        updateTrackers()
    }

    func deleteTracker(with indexPath: IndexPath) {
        let tracker = getTracker(by: indexPath)
        storage.deleteTracker(with: tracker.id)
        updateTrackers()
    }
    
    func setError(error: String?) {
        self.error = error
    }
    
    func reset(_ tracker: Tracker? = nil, categoryName: String) {
        week = defaultWeek
        if let tracker {
            self.newTracker = NewTracker(from: tracker)
        } else {
            newTracker = defaultNewTracker
        }
        changeCategory(categoryName: categoryName)
    }
    
    func addFilter(indexPath: IndexPath) {
        filter = filters[indexPath.row]
        if filter == .today {
            resetDatePicker()
            changeSelectedDay(selectedDay: Date())
        } else {
            updateTrackers()
        }
        updateFilters()
    }
}
