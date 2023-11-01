//
//  TrackerStore.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 25.10.2023.
//
import CoreData
import UIKit

final class TrackerStore: NSObject {
    //MARK: - Public variables
    static let shared = TrackerStore()
    
    //MARK: - Private variables
    private let context: NSManagedObjectContext
    private var fetchedResultController: NSFetchedResultsController<TrackerCoreData>!
    private let daysValueTransformer = DaysValueTransformer.shared
    private let trackerCaregoryStore = TrackerCategoryStore.shared
    
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
}

//MARK: - Private functions
private extension TrackerStore {
    func addTrackerTo(_ tracker: Tracker, categoryCoreData: TrackerCategoryCoreData) {        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.shedule = daysValueTransformer.weekDaysToString(tracker.shedule)
        
        categoryCoreData.addToTrackers(trackerCoreData)
        CoreDataStack.shared.saveContext(context)
        try? fetchedResultController.performFetch()
    }
}
