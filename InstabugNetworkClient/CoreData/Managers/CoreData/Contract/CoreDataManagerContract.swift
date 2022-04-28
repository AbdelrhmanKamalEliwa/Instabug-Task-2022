//
//  CoreDataManagerContract.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import Foundation
import CoreData

protocol CoreDataManagerContract {
    var context: NSManagedObjectContext { get }
}
