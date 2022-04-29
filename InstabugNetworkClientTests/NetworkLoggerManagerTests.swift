//
//  NetworkLoggerManagerTests.swift
//  InstabugNetworkClientTests
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import XCTest
import CoreData
@testable import InstabugNetworkClient

class NetworkLoggerManagerTests: XCTestCase {
    // MARK: - PROPERRTIES
    //
    private var sut: NetworkLoggerManagerContract!
    
    // MARK: - LIFECYCLE
    //
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkLoggerManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
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
        let payload: Data = .init(repeating: .init(), count: 200)
        
        let log: LogDataModel = .init(
            domainError: nil,
            errorCode: nil,
            requestMethod: "GET",
            requestPayload: payload,
            requestURL: nil,
            responsePayload: payload,
            responseStatusCode: 200
        )
        
        // When
        sut.saveLog(log)
        
        // Then
        XCTAssertEqual(sut.fetchLogs().last?.requestPayload, payload)
        XCTAssertEqual(sut.fetchLogs().last?.responsePayload, payload)
    }
    
    func testSUT_whenSaveLogsLargerThan1MBSize_logSavedWithPayloadDescriptionIneasted() {
        // Given
        let largePayload: Data = .init(repeating: .init(), count: 1050)
        let largePayloadDescription: Data? = "payload too large".data(using: .utf8)
        
        let log: LogDataModel = .init(
            domainError: nil,
            errorCode: nil,
            requestMethod: "GET",
            requestPayload: largePayload,
            requestURL: nil,
            responsePayload: largePayload,
            responseStatusCode: 200
        )
        
        // When
        sut.saveLog(log)
        
        // Then
        XCTAssertEqual(sut.fetchLogs().last?.requestPayload, largePayloadDescription)
        XCTAssertEqual(sut.fetchLogs().last?.responsePayload, largePayloadDescription)
    }
}
