//
//  NetworkLoggerManagerContract.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

protocol NetworkLoggerManagerContract {
    func fetchLogs() -> [NetworkLogger]
    func fetchLogsData() -> [LogDataModel]
    func saveLog(_ log: LogDataModel)
    func deleteLogs()
}
