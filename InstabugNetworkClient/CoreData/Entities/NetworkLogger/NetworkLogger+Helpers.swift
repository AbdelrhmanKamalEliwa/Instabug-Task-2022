//
//  NetworkLogger+Helpers.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import Foundation

extension NetworkLogger {
    static var entityName: String {
        "NetworkLogger"
    }
    
    enum Properties {
        static let id = "id"
        static let requestMethod = "requestMethod"
        static let requestURL = "requestURL"
        static let requestPayload = "requestPayload"
        static let responseStatusCode = "responseStatusCode"
        static let responsePayload = "responsePayload"
        static let domainError = "domainError"
        static let errorCode = "errorCode"
        static let creationDate = "creationDate"
    }
}

extension NetworkLogger {
    func getRequestPayload(with size: Int) -> Data? {
        guard let data = self.requestPayload else { return nil }
        return data.isBiggerThanInMegaBytes(size) ? "payload too large".data(using: .utf8) : requestPayload
    }
    
    func getResponsePayload(with size: Int) -> Data? {
        guard let data = self.responsePayload else { return nil }
        return data.isBiggerThanInMegaBytes(size) ? "payload too large".data(using: .utf8) : responsePayload
    }
}
