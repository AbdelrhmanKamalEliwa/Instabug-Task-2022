//
//  NetworkLogger+CoreDataProperties.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//
//

import Foundation
import CoreData

extension NetworkLogger {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NetworkLogger> {
        return NSFetchRequest<NetworkLogger>(entityName: "NetworkLogger")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var requestMethod: String?
    @NSManaged public var requestURL: String?
    @NSManaged public var requestPayload: Data?
    @NSManaged public var responseStatusCode: String?
    @NSManaged public var responsePayload: Data?
    @NSManaged public var domainError: String?
    @NSManaged public var errorCode: String?
    @NSManaged public var creationDate: Date?

}

extension NetworkLogger: Identifiable {

}
