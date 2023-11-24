//
//  TrackerCategoryStore.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 25.10.2023.
//

import UIKit
import CoreData

//MARK: - Protocols
protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(_ categoryStore: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate)
}

//MARK: - TrackerCategoryStore
final class TrackerCategoryStore: NSObject {
    //MARK: - Public variables
    static let shared = TrackerCategoryStore()
    weak var delegate: TrackerCategoryStoreDelegate?
    
    //MARK: - Private variables
    private let context: NSManagedObjectContext
    private let daysValueTransformer = DaysValueTransformer.shared
    private var fetchedResultController: NSFetchedResultsController<TrackerCategoryCoreData>?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerCategoryStoreUpdate.Move>?
    
    //MARK: - Initialization
    convenience override init() {
        let context = CoreDataStack.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
        try? controller.performFetch()
    }
    
    //MARK: - Public functions
    func fetchCategories() throws -> [TrackerCategory] {
        guard let fetchedResultController = fetchedResultController,
              let fetchedObjects = fetchedResultController.fetchedObjects,
              let categories = try? fetchedObjects.map({
                  try self.convertToTrackerCategory(data: $0)
              }) else {
            return []
        }
        return categories
    }
    
    func fetchCategoriesCoreData(categoryName: String) throws -> [TrackerCategoryCoreData] {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: " %K == %@",
            #keyPath(TrackerCategoryCoreData.header),
            categoryName
        )
        return try context.fetch(fetchRequest)
    }
    
    func addNewCategory(category: TrackerCategory) throws {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.header = category.header
        
        CoreDataStack.shared.saveContext(context)
        
        guard let fetchedResultController = fetchedResultController else { return }
        try? fetchedResultController.performFetch()
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerCategoryStoreUpdate.Move>()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let insertedIndexes = insertedIndexes,
              let deletedIndexes = deletedIndexes,
              let updatedIndexes = updatedIndexes,
              let movedIndexes = movedIndexes else {
            return
        }
        delegate?.store(
            self,
            didUpdate: TrackerCategoryStoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes,
                updatedIndexes: updatedIndexes,
                movedIndexes: movedIndexes
            )
        )
        self.insertedIndexes = nil
        self.deletedIndexes = nil
        self.updatedIndexes = nil
        self.movedIndexes = nil
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

//MARK: - Private functions
private extension TrackerCategoryStore {
    func convertToTrackerCategory(data: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let header = data.header,
              let trackersCoreData = data.trackers?.allObjects as? [TrackerCoreData] else {
            
            throw TrackerBaseError.error
        }
        let trackers = convertToTrackers(trackersCoreData)
        return TrackerCategory(header: header, trackers: trackers)
    }
    
    func convertToTrackers(_ trackersCoreData: [TrackerCoreData]) -> [Tracker] {
        var result: [Tracker] = []
        
        trackersCoreData.forEach { trackerCoreData in
            guard let id = trackerCoreData.id,
                  let name = trackerCoreData.name,
                  let color = trackerCoreData.color as? UIColor,
                  let emoji = trackerCoreData.emoji,
                  let strShedule = trackerCoreData.shedule else {
                return
            }
            
            result.append(
                Tracker(
                    id: id,
                    name: name,
                    color: color,
                    emoji: emoji,
                    shedule: daysValueTransformer.stringToWeekDays(strShedule)
                )
            )
        }
        
        return result
    }
}
