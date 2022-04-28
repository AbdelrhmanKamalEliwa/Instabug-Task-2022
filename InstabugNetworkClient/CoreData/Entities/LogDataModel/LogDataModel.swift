//
//  LogDataModel.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import Foundation

public struct LogDataModel {
    let creationDate: Date? = Date()
    let domainError: String?
    let errorCode: Int?
    let id: UUID? = UUID()
    let requestMethod: String?
    let requestPayload: Data?
    let requestURL: String?
    let responsePayload: Data?
    let responseStatusCode: Int?
}
