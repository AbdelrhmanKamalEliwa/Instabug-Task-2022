//
//  CoreDataManager.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import Foundation
import CoreData

class CoreDataManager: CoreDataManagerContract {
    // MARK: - SINGLETON
    //
    static let shared: CoreDataManager = CoreDataManager()
    
    // MARK: - PROPERTIES
    //
    public lazy var context: NSManagedObjectContext = {
        NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    }()
    
    // MARK: - INIT
    //
    private init() {
        setupCoreDataStack(for: .networkLogger)
    }
}

// MARK: - PRIVATE METHODS
//
private extension CoreDataManager {
    /// Setup the CoreData
    ///
    func setupCoreDataStack(
        for store: CoreDataStoreName
    ) {
        createManagedObjectModel(.networkLogger)
    }
    
    /// Creating the ManagedObjectModel
    ///
    func createManagedObjectModel(
        _ resourceName: CoreDataStoreName
    ) {
        guard
            let modelURL = Bundle.main.url(forResource: resourceName.rawValue, withExtension: "momd")
        else {
            fatalError("Failed to find data model")
        }
        
        guard
            let mom = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Failed to create model from file: \(modelURL)")
        }
        
        createAndAddPersistentStoreCoordinator(.networkLogger, managedObjectModel: mom)
    }
    
    func createAndAddPersistentStoreCoordinator(
        _ resourceName: CoreDataStoreName,
        managedObjectModel mom: NSManagedObjectModel
    ) {
        /// Create PersistentStoreCoordinator
        ///
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        /// Add PersistentStoreCoordinator
        ///
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = URL(string: "\(resourceName.rawValue).sql", relativeTo: dirURL)
        do {
            try psc
                .addPersistentStore(
                    ofType: NSSQLiteStoreType,
                    configurationName: nil,
                    at: fileURL, options: nil
                )
            
            createManagedObjectContext(persistentStoreCoordinator: psc)
        } catch {
            fatalError("Error configuring persistent store: \(error)")
        }
    }
    
    /// Create the ManagedObjectContext
    ///
    func createManagedObjectContext(
        persistentStoreCoordinator psc: NSPersistentStoreCoordinator
    ) {
        context.persistentStoreCoordinator = psc
    }
}
