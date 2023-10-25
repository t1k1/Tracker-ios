//
//  Mock.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 09.10.2023.
//

import Foundation

final class MockData {
    static let shared = MockData()
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(
            header: "Стандартная категория",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Стандартный трекер",
                    color: .ypRed,
                    emoji: "🍒",
                    shedule: [WeekDay.monday]
                )
            ]
        )
    ]
    
    private init() {}
    
    func getCategories() -> [TrackerCategory] {
        return categories
    }
    
    func addCategory(categoryName: String, trackers: [Tracker]) {
        categories.append(TrackerCategory(header: categoryName, trackers: trackers))
    }
    
    func addTrackerInCategory(category categoryOfNewTracker: TrackerCategory, tracker newTracker: Tracker) {
        let categoryName = categoryOfNewTracker.header
        
        let index = categories.firstIndex { $0.header == categoryName }
        guard let index = index else { return }
        
        var trackers: [Tracker] = []
        categories[index].trackers.forEach { tracker in
            trackers.append(tracker)
        }
        trackers.append(newTracker)
        
        categories.remove(at: index)
        addCategory(categoryName: categoryName, trackers: trackers)
    }
}
