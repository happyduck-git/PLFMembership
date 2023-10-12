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

extension String {
    func removeHexPrefixAndLeadingZeros() -> String {
        // Remove the "0x" prefix if it exists
        let stringWithoutPrefix = self.hasPrefix("0x") ? String(self.dropFirst(2)) : self
        
        // Remove leading zeros
        let result = stringWithoutPrefix.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
        
        return result.isEmpty ? "0" : result
    }
}
