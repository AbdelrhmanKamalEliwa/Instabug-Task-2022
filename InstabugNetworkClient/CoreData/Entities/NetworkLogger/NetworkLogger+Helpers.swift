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
