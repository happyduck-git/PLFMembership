//
//  EnvironmentConfig.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/26.
//

import Foundation

public enum EnvironmentConfig {
    enum Keys: String {
        case alchemyAPIKey = "ALCHEMY_API_KEY"
        case sbtContractAddress = "SBT_CONTRACT_ADDRESS_VALUE"
        case coffeeCouponContractAddress = "COFFEE_CONTRACT_ADDRESS_VALUE"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let alchemyAPIKey: String = {
        guard let value = EnvironmentConfig.infoDictionary[Keys.alchemyAPIKey.rawValue] as? String else {
            fatalError("uplusContractAddress not set in plist for this environment")
        }
        
        return value
    }()

    static let sbtContractAddress: String = {
        guard let value = EnvironmentConfig.infoDictionary[Keys.sbtContractAddress.rawValue] as? String else {
            fatalError("sbtContractAddress not set in plist for this environment")
        }
        
        return value
    }()
    
    static let coffeeCouponContractAddress: String = {
        guard let value = EnvironmentConfig.infoDictionary[Keys.coffeeCouponContractAddress.rawValue] as? String else {
            fatalError("coffeeCouponContractAddress not set in plist for this environment")
        }
        
        return value
    }()
}
