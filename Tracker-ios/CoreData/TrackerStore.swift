//
//  TrackerStore.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 25.10.2023.
//
import CoreData
import UIKit

final class TrackerStore {
    private let context = CoreDataStack.shared.context
    private let daysValueTransformer = DaysValueTransformer()
    
    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateExistingTracker(trackerCoreData, with: tracker)
        CoreDataStack.shared.saveContext(context)
    }
    
    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.id = tracker.id
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.shedule = daysValueTransformer.transformedValue(tracker.shedule) as? NSObject
    }
    
    func fetchTrackers() throws -> [Tracker] {
        let fetchRequest = TrackerCoreData.fetchRequest()
        let trackers = try context.fetch(fetchRequest)
        return try trackers.map({ try self.tracker(from: $0) })
    }
    
    func tracker(from data: TrackerCoreData) throws -> Tracker {
        guard let id = data.id,
              let name = data.name,
              let color = data.color as? UIColor,
              let emoji = data.emoji,
              let shedule = daysValueTransformer.reverseTransformedValue(data.shedule) as? [WeekDay] else {
            
            throw TrackerBaseError.error
        }
        return Tracker(id: id,
                       name: name,
                       color: color,
                       emoji: emoji,
                       shedule: shedule
        )
    }
}
