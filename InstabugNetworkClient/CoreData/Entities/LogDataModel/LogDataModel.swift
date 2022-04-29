//
//  LogDataModel.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import Foundation

public struct LogDataModel {
    public let creationDate: Date?
    public let domainError: String?
    public let errorCode: Int?
    public let id: UUID?
    public let requestMethod: String?
    public let requestPayload: Data?
    public let requestURL: String?
    public let responsePayload: Data?
    public let responseStatusCode: Int?
    
    public init(
        creationDate: Date? = Date(),
        domainError: String?,
        errorCode: Int?,
        id: UUID? = UUID(),
        requestMethod: String?,
        requestPayload: Data?,
        requestURL: String?,
        responsePayload: Data?,
        responseStatusCode: Int?
    ) {
        self.creationDate = creationDate
        self.domainError = domainError
        self.errorCode = errorCode
        self.id = id
        self.requestMethod = requestMethod
        self.requestPayload = requestPayload
        self.requestURL = requestURL
        self.responsePayload = responsePayload
        self.responseStatusCode = responseStatusCode
    }
}
