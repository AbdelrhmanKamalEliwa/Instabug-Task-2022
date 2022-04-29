//
//  NetworkLoggerManagerTests.swift
//  InstabugNetworkClientTests
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import XCTest
@testable import InstabugNetworkClient
import CoreData

class NetworkLoggerManagerTests: XCTestCase {
    // MARK: - PROPERRTIES
    //
    private var sut: NetworkLoggerManagerContract!
    
    // MARK: - LIFECYCLE
    //
    override func setUp() {
        super.setUp()
        
        /// to store data into the runtime memory instead
        LoggerDataManager.shared.storeType = NSInMemoryStoreType
        
        sut = NetworkLoggerManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - METHODS
    //
    func testSUT_whenFetchLogsDataForFirstTime_logsAreEmptyTrue() {
        // When
        let logs: [LogDataModel] = sut.fetchLogsData()
        
        // Then
        XCTAssertTrue(logs.isEmpty)
    }
    
    func testSUT_whenSaveLogsWithLessThan1MBSize_logSavedSucccessfullyWithOriginalPayload() {
        // Given
        let payload: Data = MockData.payload
        let log: LogDataModel = MockData.log
        
        // When
        sut.saveLog(log)
        
        // Then
        XCTAssertEqual(sut.fetchLogs().last?.requestPayload, payload)
        XCTAssertEqual(sut.fetchLogs().last?.responsePayload, payload)
    }
    
    func testSUT_whenSaveLogsLargerThan1MBSize_logSavedWithPayloadDescriptionIneasted() {
        // Given
        let largePayloadDescription: Data? = MockData.largePayloadDescription
        let log: LogDataModel = MockData.logWithLargePayload
        
        // When
        sut.saveLog(log)
        
        // Then
        XCTAssertEqual(sut.fetchLogs().last?.requestPayload, largePayloadDescription)
        XCTAssertEqual(sut.fetchLogs().last?.responsePayload, largePayloadDescription)
    }
    
    func testSUT_whenSaveNewLogger_andRowsCountIsMax_loggerSavedSuccessfully() {
        // Given
        let logs: [LogDataModel] = MockData._1001_logs
        
        // When
        logs.forEach { sut.saveLog($0) }
        let cachedLogs: [LogDataModel] = sut.fetchLogsData()
        
        // Then
        XCTAssertLessThanOrEqual(cachedLogs.count, MockData.maxRows)
    }
    
    func testSUT_whenCallDeleteAll_logsAreEmptyTrue() {
        // Given
        let logs: [LogDataModel] = Array(repeating: MockData.log, count: 10)
        
        // When
        logs.forEach { sut.saveLog($0) }
        sut.deleteAll()
        let savedLogs: [LogDataModel] = sut.fetchLogsData()
        
        // Then
        XCTAssertTrue(savedLogs.isEmpty)
    }
}
