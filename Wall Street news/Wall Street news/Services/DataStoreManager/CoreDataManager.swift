//
//  CoreDataManager.swift
//  Wall Street news
//
//  Created by Егор on 31.07.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()
    
    func entityForName(name: String) -> NSEntityDescription? {
        guard let entityName = NSEntityDescription.entity(forEntityName: name, in: context) else { return nil }
        return entityName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataStoreManager")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolver error\(error), \(error.userInfo)")
            }
        }
    return container
    }()
    
    func saveContext() {
        let context = persistentContainer.newBackgroundContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
}
