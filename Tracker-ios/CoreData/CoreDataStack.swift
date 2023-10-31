//
//  CoreDataContainer.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 25.10.2023.
//

import Foundation
import CoreData

enum TrackerBaseError: Error {
    case error
}

final class CoreDataStack {
    //MARK: - Public variables
    static let shared = CoreDataStack()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerBase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Не удалось загрузить базу данных!")
            }
        })
        return container
    }()
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //MARK: - Initialization
    private init() {}
    
    //MARK: - Public functions
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Не удалось сохранить контекст!")
                context.rollback()
            }
        }
    }
}
