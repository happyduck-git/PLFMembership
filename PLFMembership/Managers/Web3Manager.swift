//
//  Web3Manager.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/27.
//

import Foundation
import BigInt
import web3

final actor Web3Manager {
    
    static let shared = Web3Manager()
    
    private init() {}
    
}

extension Web3Manager {
    
    func getTokenUri(of tokenId: BigUInt) async -> String? {
        do {
            let urlString = await AlchemyServiceManager.shared.builUrlString(chain: .polygon,
                                                                             network: .mumbai,
                                                                             api: .transfers)
            guard let url = URL(string: urlString) else {
                PLFLogger.logger.error("Error converting url string to url.)")
                return nil
            }
            
            let client = EthereumHttpClient(url: url)
            let contract = IdCardNFTContract(contract: EnvironmentConfig.sbtContractAddress, client: client)
            
            return try await contract.tokenURI(tokenId: tokenId)
        }
        catch {
            PLFLogger.logger.error("Error getting token uri -- \(String(describing: error))")
            return nil
        }
    }
    
}

// MARK: - Get Employee SBT Input Data
extension Web3Manager {
    
    /// Get SBT tier Infomation.
    /// - Parameter address: Owner's wallet address.
    func getUserTier(address: String) async -> BigUInt {
        do {
            let urlString = await AlchemyServiceManager.shared.builUrlString(chain: .polygon,
                                                                             network: .mumbai,
                                                                             api: .transfers)
            guard let url = URL(string: urlString) else {
                PLFLogger.logger.error("Error converting url string to url.)")
                return 0
            }
            
            let client = EthereumHttpClient(url: url)
            let contract = IdCardNFTContract(contract: EnvironmentConfig.sbtContractAddress, client: client)
            client.getEvents(addresses: <#T##[EthereumAddress]?#>,
                             topics: <#T##[String?]?#>,
                             fromBlock: <#T##EthereumBlock#>,
                             ' toBlock: <#T##EthereumBlock#>,
                             matching: <#T##[EventFilter]#>)
            return try await contract.getCurrentUserTier(user: EthereumAddress(address))
        }
        catch {
            PLFLogger.logger.error("Error getting user tier -- \(String(describing: error))")
            return 0
        }
    }
    
}

// MARK: - Get CoffeeCoupon Input Data
extension Web3Manager {
    
    /// Get Coffee Coupon Infomation.
    /// - Parameter tokenId: Token id of the coffee coupon nft.
    func getCoffeeCoupon(tokenId: Int64) async -> CoffeeCoupon? {
        do {
            let urlString = await AlchemyServiceManager.shared.builUrlString(chain: .polygon,
                                                                             network: .mumbai,
                                                                             api: .transfers)
            guard let url = URL(string: urlString) else {
                PLFLogger.logger.error("Error converting url string to url.)")
                return nil
            }
            
            let client = EthereumHttpClient(url: url)
            let contract = CoffeeNFTContract(contract: EnvironmentConfig.coffeeCouponContractAddress, client: client)
            
            let result = try await contract.getCoffeeCoupon(tokenId: BigUInt(tokenId))
            
            return self.decodeJSON(from: result)
        }
        catch {
            PLFLogger.logger.error("Error getting coffee -- \(String(describing: error))")
            return nil
        }
        
    }
    
    private func decodeJSON(from jsonString: String) -> CoffeeCoupon? {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let coupon = try decoder.decode(CoffeeCoupon.self, from: jsonData)
                return coupon
            } catch {
                PLFLogger.logger.error("Error decoding JSON: \(String(describing: error))")
            }
        }
        return nil
    }
}
