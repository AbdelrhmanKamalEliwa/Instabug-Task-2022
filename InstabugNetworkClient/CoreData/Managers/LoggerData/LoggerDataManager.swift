//
//  LoggerDataManager.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import Foundation
import CoreData

class LoggerDataManager {
    static let shared: LoggerDataManager = LoggerDataManager()
    
    private lazy var context: NSManagedObjectContext = {
        NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    }()
    
    private init() {
        setupCoreDataStack(for: .networkLogger)
    }
}

// MARK: - PRIVATE METHODS
//
private extension LoggerDataManager {
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
            let modelURL = Bundle(for: LoggerDataManager.self)
                .url(forResource: resourceName.rawValue, withExtension: "momd")
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
    
    func createNewLogger(from log: LogDataModel, with maxPayloadSize: Int) {
        let newLogger = NSEntityDescription.insertNewObject(
            forEntityName: NetworkLogger.entityName, into: context
        )
        
        newLogger.setValue(log.id, forKeyPath: NetworkLogger.Properties.id)
        newLogger.setValue(log.requestMethod, forKeyPath: NetworkLogger.Properties.requestMethod)
        newLogger.setValue(log.requestURL, forKeyPath: NetworkLogger.Properties.requestURL)
        newLogger.setValue(
            log.getRequestPayload(with: maxPayloadSize),
            forKeyPath: NetworkLogger.Properties.requestPayload
        )
        newLogger.setValue(log.responseStatusCode, forKeyPath: NetworkLogger.Properties.responseStatusCode)
        newLogger.setValue(
            log.getResponsePayload(with: maxPayloadSize),
            forKeyPath: NetworkLogger.Properties.responsePayload
        )
        newLogger.setValue(log.domainError, forKeyPath: NetworkLogger.Properties.domainError)
        newLogger.setValue(log.errorCode, forKeyPath: NetworkLogger.Properties.errorCode)
        newLogger.setValue(log.creationDate, forKeyPath: NetworkLogger.Properties.creationDate)
    }
}

// MARK: - LoggerDataManagerContract METHODS
//
extension LoggerDataManager: LoggerDataManagerContract {
    func fetchLogs() -> [NetworkLogger] {
        var logs: [NetworkLogger] = []
        
        let fetchRequest = NSFetchRequest<NetworkLogger>(entityName: NetworkLogger.entityName)
        let sortByDate = NSSortDescriptor(key: NetworkLogger.Properties.creationDate, ascending: true)
        fetchRequest.sortDescriptors = [sortByDate]
        fetchRequest.returnsObjectsAsFaults = false
        
        context.performAndWait {
            do {
                logs = try context.fetch(fetchRequest)
            } catch {
                fatalError("Unable to fetch logs due to: \(error.localizedDescription)")
            }
        }
        
        return logs
    }
    
    func saveLog(_ log: LogDataModel, with maxRows: Int, and maxPayloadSize: Int) {
        let logs: [NetworkLogger] = fetchLogs()
        
        context.performAndWait {
            
            if
                logs.count >= maxRows,
                let firstLog = logs.first,
                let existedLog = try? context.existingObject(with: firstLog.objectID) {
                
                context.delete(existedLog)
            }
            
           createNewLogger(from: log, with: maxPayloadSize)
            
            do {
                try context.save()
            } catch {
                fatalError("Unable to save log due to: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NetworkLogger.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        context.performAndWait {
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                fatalError("Unable to delete logs due to: \(error.localizedDescription)")
            }
        }
    }
}
