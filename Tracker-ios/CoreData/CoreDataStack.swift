//
//  CoreDataContainer.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 25.10.2023.
//

import Foundation
import CoreData

final class CoreDataStack {
    //MARK: - Public variables
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerBase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Не удалось загрузить базу данных!")
            }
        })
        return container
    }()
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    //MARK: - Initialization
    private init() {}
    
    //MARK: - Public functions
    func contextSave(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("Не удалось сохранить контекст!")
            }
        }
    }
}
