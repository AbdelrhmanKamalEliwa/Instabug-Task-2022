//
//  NetworkLoggerManager.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 27/04/2022.
//

import Foundation

class NetworkLoggerManager {
    // MARK: - PROPERTIES
    //
    private let dataManager: LoggerDataManagerContract
    private let logsLimit: Int
    private let payloadSizeInMegaBytes: Int
    
    // MARK: - INIT
    //
    init(
        dataManager: LoggerDataManagerContract = LoggerDataManager.shared,
        logsLimit: Int = 1000,
        payloadSizeLimit: Int = 1
    ) {
        self.dataManager = dataManager
        self.logsLimit = logsLimit
        self.payloadSizeInMegaBytes = payloadSizeLimit
        
        self.deleteAll()
    }
}

// MARK: - NetworkLoggerManagerContract METHODS
//
extension NetworkLoggerManager: NetworkLoggerManagerContract {
    func fetchLogsData() -> [LogDataModel] {
        dataManager
            .fetchLogs()
            .map {
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
        dataManager.fetchLogs()
    }
    
    func saveLog(_ log: LogDataModel) {
        dataManager.saveLog(log, with: logsLimit, and: payloadSizeInMegaBytes)
    }
    
    func deleteAll() {
        dataManager.deleteAll()
    }
}
