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
    
    var storeType: String = NSSQLiteStoreType
    
    private lazy var mainContext: NSManagedObjectContext = {
        NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    }()
    
    private init() {
        setupCoreDataStack(for: .networkLogger)
    }
}

// MARK: - SETUP COREDATA STACK
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
        
        createPersistentContainer(.networkLogger, managedObjectModel: mom)
    }
    
    func createPersistentContainer(
        _ resourceName: CoreDataStoreName,
        managedObjectModel mom: NSManagedObjectModel
    ) {
        let persistentContainer = NSPersistentContainer(
            name: resourceName.rawValue,
            managedObjectModel: mom
        )
        
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = storeType
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error configuring persistent store: \(error)")
            }
        }
        
        createMainContext(persistentContainer: persistentContainer)
        createBackgroundContext(persistentContainer: persistentContainer)
    }
    
    /// Create the Main ManagedObjectContext
    ///
    func createMainContext(
        persistentContainer pc: NSPersistentContainer
    ) {
        let mainContext = pc.viewContext
        mainContext.automaticallyMergesChangesFromParent = true
        self.mainContext = mainContext
    }
    
    /// Create the Background ManagedObjectContext
    ///
    func createBackgroundContext(
        persistentContainer pc: NSPersistentContainer
    ) {
        let backgroundContext = pc.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        self.backgroundContext = backgroundContext
    }
}

// MARK: - PRIVATE HELPER METHODS
//
private extension LoggerDataManager {
    func createNewLogger(from log: LogDataModel, with maxPayloadSize: Int) {
        let newLogger = NSEntityDescription.insertNewObject(
            forEntityName: NetworkLogger.entityName, into: backgroundContext
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
        
        mainContext.performAndWait {
            do {
                logs = try mainContext.fetch(fetchRequest)
            } catch {
                fatalError("Unable to fetch logs due to: \(error.localizedDescription)")
            }
        }
        
        return logs
    }
    
    func saveLog(_ log: LogDataModel, with maxRows: Int, and maxPayloadSize: Int) {
        let logs: [NetworkLogger] = fetchLogs()
        
        backgroundContext.performAndWait {
            if
                logs.count >= maxRows,
                let firstLog = logs.first,
                let existedLog = try? backgroundContext.existingObject(with: firstLog.objectID) {
                
                backgroundContext.delete(existedLog)
            }
            
           createNewLogger(from: log, with: maxPayloadSize)
            
            do {
                try backgroundContext.save()
            } catch {
                fatalError("Unable to save log due to: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NetworkLogger.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        backgroundContext.performAndWait {
            do {
                try backgroundContext.execute(deleteRequest)
                try backgroundContext.save()
            } catch {
                fatalError("Unable to delete logs due to: \(error.localizedDescription)")
            }
        }
    }
}
