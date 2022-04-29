//
//  LoggerDataManagerContract.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import Foundation

protocol LoggerDataManagerContract {
    func fetchLogs() -> [NetworkLogger]
    func saveLog(_ log: LogDataModel, with maxRows: Int, and maxPayloadSize: Int)
    func deleteAll()
}
