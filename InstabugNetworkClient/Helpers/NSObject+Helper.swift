//
//  NSObject+Helper.swift
//  InstabugNetworkClient
//
//  Created by Abdelrhman Eliwa on 29/04/2022.
//

import Foundation

extension NSObject {
    /// Returns the receiver's classname as a string, not including the namespace.
    class var classNameWithoutNamespaces: String {
        return String(describing: self)
    }
}
