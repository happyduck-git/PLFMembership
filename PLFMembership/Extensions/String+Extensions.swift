//
//  String+Extensions.swift
//  PLFMembership
//
//  Created by Platfarm on 10/11/23.
//

import Foundation

extension String {
    func hexStringToInt64() -> Int64? {
        // Remove the "0x" prefix if it exists
        let cleanString = self.hasPrefix("0x") ? String(self.dropFirst(2)) : self
        
        // Convert the cleaned hex string to Int64
        return Int64(cleanString, radix: 16)
    }
}
