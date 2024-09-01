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
    private let defaultWeek = DayOfWeek.allCases.map { DayOfWeekSwitch(dayOfWeek: $0, isEnabled: false) }
    private let defaultNewTracker = NewTracker(frequency: .regular, name: "", color: "", emoji: "", schedule: "")
    
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
    
    var filteredTrackers: [TrackerCategory] {
        storage.getCategories().map {
            TrackerCategory(title: $0.title,
                            trackers: $0.trackers.filter {
                
                if $0.schedule.isEmpty {
                    return true
                }
                let schedule = DayOfWeek.stringToSchedule(scheduleString: $0.schedule).map { String(describing: $0.dayOfWeek)}
                let selectedDayOfWeek = selectedDay.dateToString()
                return schedule.contains(selectedDayOfWeek)
            })
        } .filter { !$0.trackers.isEmpty }
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
    
    func isTrackerCompleteForSelectedDay(trackerUUID: UUID) -> Int {
        let records = storage.getRecords(of: trackerUUID)
        return records.firstIndex(where: { Calendar.current.isDate($0.date, equalTo: selectedDay, toGranularity: .day) }) ?? -1
    }
    
    // MARK: - Creation methods
    
    func updateTrackers() {
        NotificationCenter.default.post(name: TrackerViewController.reloadCollection, object: self)
    }
    
    func updateCreation() {
        NotificationCenter.default.post(name: TrackerCreationViewController.reloadCollection, object: self)
    }
    
    func createTracker(category: String) {
        let tracker = Tracker(newTracker)
        storage.createTracker(with: tracker, categoryName: category)
        updateTrackers()
    }
    
    func changeColor(color: String?) {
        self.newTracker = newTracker.update(color: color ?? "")
        updateCreation()
    }
    
    func changeEmoji(emoji: String?) {
        self.newTracker = newTracker.update(emoji: emoji ?? "")
        updateCreation()
    }
    
    func changeName(name: String?) {
        self.newTracker = newTracker.update(name: name ?? "")
        updateCreation()
    }
    
    func changeSchedule() {
        let schedule = DayOfWeek.scheduleToString(schedule: week)
        self.newTracker = newTracker.update(schedule: schedule)
        updateCreation()
    }
    
    func changeSelectedSchedule(indexPath: IndexPath) {
        let day = week[indexPath.row]
        week[indexPath.row].isEnabled = !day.isEnabled
        updateCreation()
    }
    
    func changeFrequency(frequency: TrackerFrequency) {
        self.newTracker = newTracker.update(frequency: frequency)
        updateCreation()
    }
    
    func getTrackerCount(trackerID: UUID) -> Int {
        storage.getRecords(of: trackerID).count
    }
    
    func setError(error: String?) {
        self.error = error
    }
    
    func reset() {
        newTracker = defaultNewTracker
        week = defaultWeek
    }
}
