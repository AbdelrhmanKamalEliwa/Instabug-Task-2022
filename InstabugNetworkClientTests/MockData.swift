//
//  MockData.swift
//  InstabugNetworkClientTests
//
//  Created by Abdelrhman Eliwa on 29/04/2022.
//

import Foundation
import InstabugNetworkClient

class MockData {
    static let maxRows: Int = 1000
    static let payload: Data = .init(repeating: .init(), count: 200)
    static let largePayload: Data = .init(repeating: .init(), count: 1050)
    static let largePayloadDescription: Data? = "payload too large".data(using: .utf8)
    
    static let log: LogDataModel = LogDataModel(
        domainError: nil,
        errorCode: nil,
        requestMethod: "GET",
        requestPayload: payload,
        requestURL: nil,
        responsePayload: payload,
        responseStatusCode: 200
    )
    
    static let logWithLargePayload: LogDataModel = LogDataModel(
        domainError: nil,
        errorCode: nil,
        requestMethod: "GET",
        requestPayload: largePayload,
        requestURL: nil,
        responsePayload: largePayload,
        responseStatusCode: 200
    )
    
    static let _1001_logs: [LogDataModel] = Array.init(repeating: log, count: maxRows + 1)
}
