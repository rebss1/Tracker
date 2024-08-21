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
    
    private(set) var selectedDay: Date = Date()
    private(set) var week: [DayOfWeekSwitch]
    private(set) var trackerRecord:  [UUID: [Date]] = [:]
    private(set) var error: String?
    private(set) var newTracker: NewTracker
    private var trackers: [TrackerCategory] = []
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
        return trackers.map { category in
                let filteredTrackers = category.trackers.filter { tracker in
                    guard !tracker.schedule.isEmpty else {
                        return true
                    }
                    let schedule = DayOfWeek.stringToSchedule(scheduleString: tracker.schedule)
                        .map { String(describing: $0.dayOfWeek) }
                    let selectedDay = selectedDay.dateToString()
                    return schedule.contains(selectedDay)
                }
                return TrackerCategory(title: category.title, trackers: filteredTrackers)
            }.filter { !$0.trackers.isEmpty }
    }
    
    func changeSelectedDay(selectedDay: Date) {
        self.selectedDay = selectedDay
        updateTrackers()
    }
    
    func updateTrackers() {
        NotificationCenter.default.post(name: TrackerViewController.reloadCollection, object: self)
    }
    
    func updateCreation() {
        NotificationCenter.default.post(name: TrackerCreationViewController.reloadCollection, object: self)
    }
    
    func createTracker(category: String) {
        let index = trackers.firstIndex(where: { $0.title == category }) ?? -1
        let tracker = Tracker(newTracker)
        if index >= 0 {
            let trackers = trackers[index].trackers + [tracker]
            let category = TrackerCategory(title: category, trackers: trackers)
            self.trackers.remove(at: index)
            self.trackers.insert(category, at: index)
        } else {
            trackers = trackers + [TrackerCategory(title: category, trackers: [tracker])]
        }
        updateTrackers()
    }
    
    func isTrackerCompleteForSelectedDay(trackerUUID: UUID) -> Int {
        guard let trackerRecord = trackerRecord[trackerUUID] else { return -1 }
        return trackerRecord.firstIndex(where: { Calendar.current.isDate($0, equalTo: selectedDay, toGranularity: .day) }) ?? -1
    }
    
    func updateDaysCounter(id: UUID) {
        if trackerRecord[id] != nil {
            let completedPerDay = isTrackerCompleteForSelectedDay(trackerUUID: id)
            if completedPerDay >= 0 {
                trackerRecord[id]?.remove(at: completedPerDay)
            } else {
                trackerRecord[id]?.append(selectedDay)
            }
        } else {
            trackerRecord[id] = [selectedDay]
        }
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
    
    func setError(error: String?) {
        self.error = error
    }
    
    func reset() {
        newTracker = defaultNewTracker
        week = defaultWeek
    }
}
