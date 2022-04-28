//
//  Data+Helpers.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 28/04/2022.
//

import Foundation

extension Data {
    func isBiggerThanInMegaBytes(_ megaBytes: Int) -> Bool {
        guard megaBytes >= 0 else {
            fatalError("MegaBytes can't be less than zero.")
        }
        
        return self.count > (megaBytes * 1024)
    }
}
