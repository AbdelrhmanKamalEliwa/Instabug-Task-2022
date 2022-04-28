//
//  NetworkLoggerManagerContract.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

protocol NetworkLoggerManagerContract {
    func fetchLogs() -> [NetworkLogger]
    func saveLog(_ log: NetworkLogger)
    func deleteLogs()
}
