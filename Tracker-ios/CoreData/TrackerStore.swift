//
//  TrackerStore.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 25.10.2023.
//
import CoreData
import UIKit

//MARK: - Protocols
protocol TrackerStoreDelegate: AnyObject {
    func store(_ categoryStore: TrackerStore, didUpdate update: TrackerStoreUpdate)
}

final class TrackerStore: NSObject {
    //MARK: - Public variables
    static let shared = TrackerStore()
    weak var delegate: TrackerStoreDelegate?
    
    //MARK: - Private variables
    private let context: NSManagedObjectContext
    private var fetchedResultController: NSFetchedResultsController<TrackerCoreData>?
    private let daysValueTransformer = DaysValueTransformer.shared
    private let trackerCaregoryStore = TrackerCategoryStore.shared
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerStoreUpdate.Move>?
    
    //MARK: - Initialization
    convenience override init() {
        let context = CoreDataStack.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]
        
        let resultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultController.delegate = self
        self.fetchedResultController = resultController
        try? resultController.performFetch()
    }
    
    //MARK: - Public functions
    func addNewTracker(tracker: Tracker, category: TrackerCategory) throws {
        var categoryCoreData = try trackerCaregoryStore.fetchCategoriesCoreData(categoryName: category.header)
        
        if categoryCoreData.isEmpty {
            try? trackerCaregoryStore.addNewCategory(category: category)
            categoryCoreData = try trackerCaregoryStore.fetchCategoriesCoreData(categoryName: category.header)
        }
        
        guard let categoryCoreData = categoryCoreData.first else { throw TrackerBaseError.error }
        
        addTrackerTo(tracker, categoryCoreData: categoryCoreData)
    }
    
    func updateTracker(categoryName: String, shedule: [WeekDay], name: String, emoji: String, color: UIColor, id: UUID) throws {
        guard let fetchedResultController = fetchedResultController else { return }
        let tracker = fetchedResultController.fetchedObjects?.first { $0.id == id }
        
        guard let tracker = tracker else { return }
        tracker.shedule = daysValueTransformer.weekDaysToString(shedule)
        tracker.emoji = emoji
        tracker.color = color
        tracker.name = name
        if tracker.category?.header != categoryName {
            tracker.category = try trackerCaregoryStore.fetchCategoriesCoreData(categoryName: categoryName).first
        }
        
        CoreDataStack.shared.saveContext(context)
    }
    
    func deleteTracker(_ tracker: Tracker) throws {
        guard let fetchedResultController = fetchedResultController else { return }
        let tracker = fetchedResultController.fetchedObjects?.first { $0.id == tracker.id }
        
        guard let tracker = tracker else { return }
        
        context.delete(tracker)
        CoreDataStack.shared.saveContext(context)
    }
    
    func changePinTracker(_ tracker: Tracker) throws {
        let fetchedTracker = fetchedResultController?.fetchedObjects?.first {
            $0.id == tracker.id
        }
        guard let fetchedTracker = fetchedTracker else { return }
        
        fetchedTracker.pinned = !(fetchedTracker.pinned)
        CoreDataStack.shared.saveContext(context)
        try? fetchedResultController?.performFetch()
    }
    
    func fetchPinnedTrackers() throws -> [Tracker] {
        var pinnedTrackers: [Tracker] = []
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "pinned == true"
        )
        
        let trackerCoreData = try context.fetch(fetchRequest)
        trackerCoreData.forEach { trackerCoreData in
            guard let id = trackerCoreData.id,
                  let name = trackerCoreData.name,
                  let color = trackerCoreData.color as? UIColor,
                  let emoji = trackerCoreData.emoji,
                  let strShedule = trackerCoreData.shedule else {
                return
            }
            
            pinnedTrackers.append(
                Tracker(
                    id: id,
                    name: name,
                    color: color,
                    emoji: emoji,
                    pinned: trackerCoreData.pinned,
                    shedule: daysValueTransformer.stringToWeekDays(strShedule)
                )
            )
        }
        
        return pinnedTrackers
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerStoreUpdate.Move>()
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
            didUpdate: TrackerStoreUpdate(
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
private extension TrackerStore {
    func addTrackerTo(_ tracker: Tracker, categoryCoreData: TrackerCategoryCoreData) {        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.pinned = tracker.pinned
        trackerCoreData.shedule = daysValueTransformer.weekDaysToString(tracker.shedule)
        
        categoryCoreData.addToTrackers(trackerCoreData)
        CoreDataStack.shared.saveContext(context)
        
        guard let fetchedResultController = fetchedResultController else { return }
        try? fetchedResultController.performFetch()
    }
}
