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
    
}
