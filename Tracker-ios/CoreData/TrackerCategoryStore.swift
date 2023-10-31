//
//  TrackerCategoryStore.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 25.10.2023.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(_ categoryStore: TrackerCategoryStore, didUpdate update: TrackerStoreUpdate)
}

final class TrackerCategoryStore: NSObject {
    static let shared = TrackerCategoryStore()
    weak var delegate: TrackerCategoryStoreDelegate?
    var trackerCategories: [TrackerCategory] {
        guard let objects = self.fetchedResultController.fetchedObjects,
              let trackerCategories = try? objects.map({ try self.trackerCategory(from: $0) }) else {
            return []
        }
        return trackerCategories
    }
    
    private let context = CoreDataStack.shared.context
    private let trackerStore = TrackerStore()
    private let daysValueTransformer = DaysValueTransformer()
    private var fetchedResultController: NSFetchedResultsController<TrackerCategoryCoreData>!
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerStoreUpdate.Move>?
    
    //TODO: Переписать инлициализацию на private init
    convenience override init() {
        let context = CoreDataStack.shared.context
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        super.init()
        
        let fetchrequest = TrackerCategoryCoreData.fetchRequest()
        fetchrequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.header, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchrequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultController = controller
        try controller.performFetch()
    }
    
    func trackerCategory(from data: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let header = data.header else { throw TrackerBaseError.error }
        
        let trackers: [Tracker] = try data.trackers?.compactMap({ tracker in
            guard let trackerCoreData = (tracker as? TrackerCoreData),
                  let id = trackerCoreData.id,
                  let name = trackerCoreData.name,
                  let color = trackerCoreData.color as? UIColor,
                  let emoji = trackerCoreData.emoji else {
                throw TrackerBaseError.error
            }
            let shedule: [WeekDay] = daysValueTransformer.reverseTransformedValue(trackerCoreData.shedule) as? [WeekDay] ?? []
            return Tracker(id: id,
                           name: name,
                           color: color,
                           emoji: emoji,
                           shedule: shedule
            )
        }) ?? []
        
        return TrackerCategory(header: header, trackers: trackers)
    }
    
    func addNewTrackerCategory(trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        updateExistingTrackerCategory(trackerCategoryCoreData, with: trackerCategory)
        CoreDataStack.shared.saveContext(context)
    }
    
    func updateExistingTrackerCategory(_ trackerCategoryCoreData: TrackerCategoryCoreData, with category: TrackerCategory) {
        trackerCategoryCoreData.header = category.header
        category.trackers.forEach { tracker in
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.name = tracker.name
            trackerCoreData.color = tracker.color
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.shedule = daysValueTransformer.transformedValue(tracker.shedule) as? NSObject
            trackerCategoryCoreData.addToTrackers(trackerCoreData)
        }
    }
    
    func addNewTracker(_ tracker: Tracker, toCategory trackerCategory: TrackerCategory) throws {
        let category = fetchedResultController.fetchedObjects?.first {
            $0.header == trackerCategory.header
        }
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.name = tracker.name
        trackerCoreData.id = tracker.id
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color
        trackerCoreData.shedule = daysValueTransformer.transformedValue(tracker.shedule) as? NSObject
        
        category?.addToTrackers(trackerCoreData)
        CoreDataStack.shared.saveContext(context)
    }
    
    func fetchPredicate(trackerName: String) -> [TrackerCategory] {
        if trackerName.isEmpty {
            return trackerCategories
        } else {
            let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "ANY trackers.nameTracker CONTAINS[cd] %@", trackerName)
            guard let trackerCategoriesCoreData = try? context.fetch(fetchRequest),
                  let categories = try? trackerCategoriesCoreData.map({ try self.trackerCategory(from: $0)}) else {
                return []
            }
        
            return categories
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerStoreUpdate.Move>()
    }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        delegate?.store(
            self,
            didUpdate: TrackerStoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!,
                updatedIndexes: updatedIndexes!,
                movedIndexes: movedIndexes!
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        movedIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
            case .insert:
                guard let indexPath = newIndexPath else { fatalError() }
                insertedIndexes?.insert(indexPath.item)
            case .delete:
                guard let indexPath = indexPath else { fatalError() }
                deletedIndexes?.insert(indexPath.item)
            case .update:
                guard let indexPath = indexPath else { fatalError() }
                updatedIndexes?.insert(indexPath.item)
            case .move:
                guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
                movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
            @unknown default:
                fatalError()
        }
    }
}
