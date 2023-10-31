//
//  TrackerRecordStore.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 25.10.2023.
//

import Foundation
import CoreData

final class TrackerRecordStore {
    static let shared = TrackerRecordStore()
    
    private let context = CoreDataStack.shared.context
    
    private init() { }
    
    func addTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        updateExistingTrackerCategory(trackerRecordCoreData, withRecord: trackerRecord)
        CoreDataStack.shared.saveContext(context)
    }
    
    func updateExistingTrackerCategory(_ trackerRecordCoreData: TrackerRecordCoreData, withRecord record: TrackerRecord) {
        trackerRecordCoreData.id = record.id
        trackerRecordCoreData.date = record.date
    }
    
    func deleteRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        updateExistingTrackerCategory(trackerRecordCoreData, withRecord: trackerRecord)
        context.delete(trackerRecordCoreData)
    }
    
    
    func fetchTrackerRecord() throws -> [TrackerRecord] {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        let trackerRecordFromCoreData = try context.fetch(fetchRequest)
        return try trackerRecordFromCoreData.map { try self.trackerRecord(from: $0) }
    }
    
    func trackerRecord(from data: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = data.id,
              let date = data.date else {
            throw TrackerBaseError.error
        }
        return TrackerRecord(id: id, date: date)
    }
}
