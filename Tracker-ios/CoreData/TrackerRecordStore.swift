//
//  TrackerRecordStore.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 25.10.2023.
//

import Foundation
import CoreData

final class TrackerRecordStore: NSObject {
    //MARK: - Public variables
    static let shared = TrackerRecordStore()
    
    //MARK: - Private variables
    private let entityName = "TrackerRecordCoreData"
    private let context: NSManagedObjectContext
    private var fetchedResultController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    //MARK: - Initialization
    convenience override init() {
        let context = CoreDataStack.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]
        let resultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        self.fetchedResultController = resultController
        try? resultController.performFetch()
    }
    
    //MARK: - Public functions
    func addTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerID = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
        
        CoreDataStack.shared.saveContext(context)
        
        guard let fetchedResultController = fetchedResultController else { return }
        try fetchedResultController.performFetch()
    }
    
    func fetchTrackerRecords() throws -> [TrackerRecord] {
        guard let fetchedResultController = fetchedResultController,
              let fetchedObjects = fetchedResultController.fetchedObjects,
              let records = try? fetchedObjects.map({
                  try self.convertToTrackerRecord(trackerRecordCoreData: $0)
              }) else {
            throw TrackerBaseError.error
        }
        
        return records
    }
    
    func fetchTrackerRecordsWith(id: UUID) throws -> [TrackerRecord] {
        var result: [TrackerRecord] = []
        
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(
            format: " %K == %@",
            #keyPath(TrackerRecordCoreData.trackerID),
            id as CVarArg
        )
        
        guard let records = try? context.fetch(fetchRequest) else { throw TrackerBaseError.error }
        
        try records.forEach { record in
            guard let trackerId = record.trackerID,
                  let date = record.date else {
                throw TrackerBaseError.error
            }
            result.append(TrackerRecord(id: trackerId, date: date))
        }
        
        return result
    }
    
    func deleteRecordWith(id: UUID, date: Date) throws {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: entityName)
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            format: " %K == %@",
            #keyPath(TrackerRecordCoreData.trackerID),
            id as CVarArg
        )
        
        guard let trackerRecords = try? context.fetch(fetchRequest),
              let deletingIndex = trackerRecords.firstIndex(where: { $0.date?.ignoringTime == date.ignoringTime } ) else {
            return
        }
        
        context.delete(trackerRecords[deletingIndex])
        CoreDataStack.shared.saveContext(context)
        
        guard let fetchedResultController = fetchedResultController else { return }
        try fetchedResultController.performFetch()
    }
}

//MARK: - Private functions
private extension TrackerRecordStore{
    func convertToTrackerRecord(trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.trackerID,
              let date = trackerRecordCoreData.date else {
            throw TrackerBaseError.error
        }
        
        return TrackerRecord(id: id, date: date)
    }
}
