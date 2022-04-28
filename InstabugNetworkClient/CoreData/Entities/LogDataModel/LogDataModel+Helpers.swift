//
//  LogDataModel+Helpers.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import Foundation

extension LogDataModel {
    func getRequestPayload(with size: Int) -> Data? {
        guard let data = self.requestPayload else { return nil }
        return data.isBiggerThanInMegaBytes(size) ? "payload too large".data(using: .utf8) : requestPayload
    }
    
    func getResponsePayload(with size: Int) -> Data? {
        guard let data = self.responsePayload else { return nil }
        return data.isBiggerThanInMegaBytes(size) ? "payload too large".data(using: .utf8) : responsePayload
    }
}
