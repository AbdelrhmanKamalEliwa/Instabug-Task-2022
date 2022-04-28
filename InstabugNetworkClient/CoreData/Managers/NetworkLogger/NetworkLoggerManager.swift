//
//  NetworkLoggerManager.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 27/04/2022.
//

import Foundation
import CoreData

class NetworkLoggerManager {
    // MARK: - PROPERTIES
    //
    private let context: NSManagedObjectContext
    private let logsLimit: Int
    private let payloadSizeInMegaBytes: Int
    
    // MARK: - INIT
    //
    init(
        context: NSManagedObjectContext = CoreDataManager.shared.context,
        logsLimit: Int = 1000,
        payloadSizeLimit: Int = 1
    ) {
        self.context = context
        self.logsLimit = logsLimit
        self.payloadSizeInMegaBytes = payloadSizeLimit
        self.deleteLogs()
    }
}

// MARK: - NetworkLoggerManagerContract METHODS
//
extension NetworkLoggerManager: NetworkLoggerManagerContract {
    func fetchLogsData() -> [LogDataModel] {
        fetchLogs().map {
            LogDataModel(
                domainError: $0.domainError,
                errorCode: Int($0.errorCode),
                requestMethod: $0.requestMethod,
                requestPayload: $0.requestPayload,
                requestURL: $0.requestURL,
                responsePayload: $0.responsePayload,
                responseStatusCode: Int($0.responseStatusCode)
            )
        }
    }
    
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
    
    func saveLog(_ log: LogDataModel) {
        let logs: [NetworkLogger] = fetchLogs()
        
        context.performAndWait {
            if logs.count >= logsLimit, let firstLog = logs.first {
                
                if let existedLog = try? context.existingObject(with: firstLog.objectID) {
                    context.delete(existedLog)
                }
            }
            
            let newLogger = NSEntityDescription.insertNewObject(
                forEntityName: NetworkLogger.entityName, into: context
            )
            
            newLogger.setValue(log.id, forKeyPath: NetworkLogger.Properties.id)
            newLogger.setValue(log.requestMethod, forKeyPath: NetworkLogger.Properties.requestMethod)
            newLogger.setValue(log.requestURL, forKeyPath: NetworkLogger.Properties.requestURL)
            newLogger.setValue(
                log.getRequestPayload(with: payloadSizeInMegaBytes),
                forKeyPath: NetworkLogger.Properties.requestPayload
            )
            newLogger.setValue(log.responseStatusCode, forKeyPath: NetworkLogger.Properties.responseStatusCode)
            newLogger.setValue(
                log.getResponsePayload(with: payloadSizeInMegaBytes),
                forKeyPath: NetworkLogger.Properties.responsePayload
            )
            newLogger.setValue(log.domainError, forKeyPath: NetworkLogger.Properties.domainError)
            newLogger.setValue(log.errorCode, forKeyPath: NetworkLogger.Properties.errorCode)
            newLogger.setValue(log.creationDate, forKeyPath: NetworkLogger.Properties.creationDate)
            
            do {
                try context.save()
            } catch {
                fatalError("Unable to save log due to: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteLogs() {
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
