//
//  LogDataModel.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import Foundation

public struct LogDataModel {
    public let creationDate: Date? = Date()
    public let domainError: String?
    public let errorCode: Int?
    public let id: UUID? = UUID()
    public let requestMethod: String?
    public let requestPayload: Data?
    public let requestURL: String?
    public let responsePayload: Data?
    public let responseStatusCode: Int?
}
