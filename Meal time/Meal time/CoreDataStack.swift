//
//  CoreDataStack.swift
//  Meal time
//
//  Created by Paul on 20.01.2019.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack  {
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Meal_time")
        let persistentStoreCoordinator = container.persistentStoreCoordinator
        // begin code to optimize
        let fileManager = FileManager.default
        let storeName = "\(container.name).sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        // end code to optimize
        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            NSMigratePersistentStoresAutomaticallyOption : true]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
//        // begin migration support block
//        let description = NSPersistentStoreDescription()
//        description.shouldMigrateStoreAutomatically = true
//        description.shouldInferMappingModelAutomatically = true
//        container.persistentStoreDescriptions =  [description]
//        // end migration support block
        
        // ! All the code above should be made more consize with
        //persistentStoreCoordinator.migratePersistentStore(<#T##store: NSPersistentStore##NSPersistentStore#>, to: <#T##URL#>, options: <#T##[AnyHashable : Any]?#>, withType: <#T##String#>)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
