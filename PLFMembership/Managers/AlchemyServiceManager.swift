//
//  AlchemyServiceManager.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/26.
//

import Foundation

final actor AlchemyServiceManager {
    // MARK: - Init
    static let shared = AlchemyServiceManager()
    private init() {}
    
    // MARK: - URL Constant
    private let baseUrl = "https://%@.g.alchemy.com"
    private let chain = "polygon"
    private let network = "mumbai"
    private let jsonKey = "application/json"
    private let acceptKey = "application/json"
    private let headerFieldContentTypeKey = "content-Type"
    
    struct TransferBodyParam {
        static let id = "id"
        static let method = "method"
        static let params = "params"
        static let fromBlock = "fromBlock"
        static let toBlock = "toBlock"
        static let fromAddress = "fromAddress"
        static let toAddress = "toAddress"
        static let category = "category"
        static let contractAddresses = "contractAddresses"
        static let getTransferMethod = "alchemy_getAssetTransfers"
        static let withMetadata = "withMetadata"
        static let erc721 = "erc721"
        static let latest = "latest"
        static let initalBlock = "0x0"
        static let idValue = 1
    }
    
}

// Get NFT Data Related
extension AlchemyServiceManager {
    
    /// Request NFT request
    /// - Returns: Owned NFTs
    func requestOwnedNFTs(ownerAddress: String,
                          contractAddresses: String) async throws -> OwnedNFTs {
      
        let urlRequest = try self.buildUrlRequest(method: .get,
                                                  chain: .polygon,
                                                  network: .mumbai,
                                                  api: .nftList,
                                                  queryParameters: [
                                                    URLQueryItem(name: "owner", value: ownerAddress),
                                                    URLQueryItem(name: "contractAddresses[]", value: contractAddresses),
                                                    URLQueryItem(name: "withMetadata", value: "true"),
                                                    URLQueryItem(name: "pageSize", value: "100")
                                                  ])
        
        
        do {
            return try await NetworkServiceManager.execute(
                expecting: OwnedNFTs.self,
                request: urlRequest
            )
        }
        catch {
            PLFLogger.logger.error("Error requesting Alchemy Service -- \(String(describing: error))")
            throw AlchemyServiceError.wrongRequest
        }
    }
    
    func requestNftMetadata(contractAddress: String, tokenId: String) async throws -> OwnedNFT {
        let urlRequest = try self.buildUrlRequest(method: .get,
                                                  chain: .polygon,
                                                  network: .mumbai,
                                                  api: .singleNftMetaData,
                                                  queryParameters: [
                                                    URLQueryItem(name: "contractAddress", value: contractAddress),
                                                    URLQueryItem(name: "tokenId", value: tokenId)
                                                  ])
        
        
        do {
            return try await NetworkServiceManager.execute(
                expecting: OwnedNFT.self,
                request: urlRequest
            )
        }
        catch {
            PLFLogger.logger.error("Error requesting Alchemy Service -- \(String(describing: error))")
            throw AlchemyServiceError.wrongRequest
        }
    }
    
}

// Get Current User's NFT Transfer Related
extension AlchemyServiceManager {
    
    /// Request SBT Token Transfer History
    /// - Returns: AlchemyTransfer type object of SBT.
    func requestCurrentOwnerSBTTransfers() async throws -> AlchemyTransfer {
        
        do {
            let urlRequest = try self.buildUrlRequest(method: .post,
                                                      chain: .polygon,
                                                      network: .mumbai,
                                                      api: .transfers,
                                                      requestBody: [TransferBodyParam.id: TransferBodyParam.idValue,
                                                                    TransferBodyParam.method: TransferBodyParam.getTransferMethod,
                                                                    TransferBodyParam.params: [
                                                                        TransferBodyParam.fromBlock: TransferBodyParam.initalBlock,
                                                                        TransferBodyParam.toBlock: TransferBodyParam.latest,
                                                                        TransferBodyParam.withMetadata: true,
                                                                        TransferBodyParam.toAddress: MainConstants.userAddress,
                                                                        TransferBodyParam.category: [TransferBodyParam.erc721],
                                                                        TransferBodyParam.contractAddresses: [EnvironmentConfig.sbtContractAddress]
                                                                    ] as [String : Any]
                                                                   ])
            
            
            return try await NetworkServiceManager.execute(
                expecting: AlchemyTransfer.self,
                request: urlRequest
            )
        }
        catch {
            PLFLogger.logger.error("Error requesting Alchemy Service -- \(String(describing: error))")
            throw AlchemyServiceError.wrongRequest
        }
    }
   
    func requestCurrentOwnerCouponTransfers() async throws -> [Transfer] {
        
        let receivedTokensRequest = try self.buildUrlRequest(method: .post,
                                                  chain: .polygon,
                                                  network: .mumbai,
                                                  api: .transfers,
                                                  requestBody: [TransferBodyParam.id: TransferBodyParam.idValue,
                                                                TransferBodyParam.method: TransferBodyParam.getTransferMethod,
                                                                TransferBodyParam.params: [
                                                                    TransferBodyParam.fromBlock: TransferBodyParam.initalBlock,
                                                                    TransferBodyParam.toBlock: TransferBodyParam.latest,
                                                                    TransferBodyParam.toAddress: MainConstants.tbaAddress,
                                                                    TransferBodyParam.withMetadata: true,
                                                                    TransferBodyParam.category: [TransferBodyParam.erc721],
                                                                    TransferBodyParam.contractAddresses: [EnvironmentConfig.coffeeCouponContractAddress]
                                                                ] as [String : Any]
                                                               ])
        
        let sentTokensRequest = try self.buildUrlRequest(method: .post,
                                                  chain: .polygon,
                                                  network: .mumbai,
                                                  api: .transfers,
                                                  requestBody: [TransferBodyParam.id: TransferBodyParam.idValue,
                                                                TransferBodyParam.method: TransferBodyParam.getTransferMethod,
                                                                TransferBodyParam.params: [
                                                                    TransferBodyParam.fromBlock: TransferBodyParam.initalBlock,
                                                                    TransferBodyParam.toBlock: TransferBodyParam.latest,
                                                                    TransferBodyParam.fromAddress: MainConstants.tbaAddress,
                                                                    TransferBodyParam.withMetadata: true,
                                                                    TransferBodyParam.category: [TransferBodyParam.erc721],
                                                                    TransferBodyParam.contractAddresses: [EnvironmentConfig.coffeeCouponContractAddress]
                                                                ] as [String : Any]
                                                               ])
        
        do {
            var result: [Transfer] = []
            
            async let received = try NetworkServiceManager.execute(
                expecting: AlchemyTransfer.self,
                request: receivedTokensRequest
            )
            
            async let sent = try NetworkServiceManager.execute(
                expecting: AlchemyTransfer.self,
                request: sentTokensRequest
            )
            
            result.append(contentsOf: try await received.result.transfers)
            result.append(contentsOf: try await sent.result.transfers)
            
            return result
        }
        catch {
            PLFLogger.logger.error("Error requesting Alchemy Service -- \(String(describing: error))")
            throw AlchemyServiceError.wrongRequest
        }
    }
}

// Get Contracts Transfer Related
extension AlchemyServiceManager {
    
    /// Request SBT Token Transfer History
    /// - Returns: AlchemyTransfer type object of SBT.
    func requestSBTContractTransfers() async throws -> AlchemyTransfer {
        
        do {
            let urlRequest = try self.buildUrlRequest(method: .post,
                                                      chain: .polygon,
                                                      network: .mumbai,
                                                      api: .transfers,
                                                      requestBody: [TransferBodyParam.id: TransferBodyParam.idValue,
                                                                    TransferBodyParam.method: TransferBodyParam.getTransferMethod,
                                                                    TransferBodyParam.params: [
                                                                        TransferBodyParam.fromBlock: TransferBodyParam.initalBlock,
                                                                        TransferBodyParam.toBlock: TransferBodyParam.latest,
                                                                        TransferBodyParam.withMetadata: true,
                                                                        TransferBodyParam.category: [TransferBodyParam.erc721],
                                                                        TransferBodyParam.contractAddresses: [EnvironmentConfig.sbtContractAddress]
                                                                    ] as [String : Any]
                                                                   ])
            
            
            return try await NetworkServiceManager.execute(
                expecting: AlchemyTransfer.self,
                request: urlRequest
            )
        }
        catch {
            PLFLogger.logger.error("Error requesting Alchemy Service -- \(String(describing: error))")
            throw AlchemyServiceError.wrongRequest
        }
    }
   
    func requestCouponContractTransfers() async throws -> [Transfer] {
        
        let receivedTokensRequest = try self.buildUrlRequest(method: .post,
                                                  chain: .polygon,
                                                  network: .mumbai,
                                                  api: .transfers,
                                                  requestBody: [TransferBodyParam.id: TransferBodyParam.idValue,
                                                                TransferBodyParam.method: TransferBodyParam.getTransferMethod,
                                                                TransferBodyParam.params: [
                                                                    TransferBodyParam.fromBlock: TransferBodyParam.initalBlock,
                                                                    TransferBodyParam.toBlock: TransferBodyParam.latest,
                                                                    TransferBodyParam.toAddress: MainConstants.tbaAddress,
                                                                    TransferBodyParam.withMetadata: true,
                                                                    TransferBodyParam.category: [TransferBodyParam.erc721],
                                                                    TransferBodyParam.contractAddresses: [EnvironmentConfig.coffeeCouponContractAddress], "maxCount": "0x3"
                                                                ] as [String : Any]
                                                               ])
        
        let sentTokensRequest = try self.buildUrlRequest(method: .post,
                                                  chain: .polygon,
                                                  network: .mumbai,
                                                  api: .transfers,
                                                  requestBody: [TransferBodyParam.id: TransferBodyParam.idValue,
                                                                TransferBodyParam.method: TransferBodyParam.getTransferMethod,
                                                                TransferBodyParam.params: [
                                                                    TransferBodyParam.fromBlock: TransferBodyParam.initalBlock,
                                                                    TransferBodyParam.toBlock: TransferBodyParam.latest,
                                                                    TransferBodyParam.fromAddress: MainConstants.tbaAddress,
                                                                    TransferBodyParam.withMetadata: true,
                                                                    TransferBodyParam.category: [TransferBodyParam.erc721],
                                                                    TransferBodyParam.contractAddresses: [EnvironmentConfig.coffeeCouponContractAddress],
                                                                    "maxCount": "0x3"
                                                                ] as [String : Any]
                                                               ])
        
        do {
            var result: [Transfer] = []
            
            async let received = try NetworkServiceManager.execute(
                expecting: AlchemyTransfer.self,
                request: receivedTokensRequest
            )
            
            async let sent = try NetworkServiceManager.execute(
                expecting: AlchemyTransfer.self,
                request: sentTokensRequest
            )
            
            result.append(contentsOf: try await received.result.transfers)
            result.append(contentsOf: try await sent.result.transfers)
            
            return result
        }
        catch {
            PLFLogger.logger.error("Error requesting Alchemy Service -- \(String(describing: error))")
            throw AlchemyServiceError.wrongRequest
        }
    }
}

extension AlchemyServiceManager {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum Chain: String {
        case polygon
    }
    
    enum Network: String {
        case mumbai
    }
    
    enum AlchemyAPI {
        case transfers
        case nftList
        case singleNftMetaData
        
        var endpoint: String? {
            switch self {
            case .nftList:
                return "getNFTs"
            case .singleNftMetaData:
                return "getNFTMetadata"
            default:
                return nil
            }
        }
    }
    
    private func buildUrlRequest(method: HTTPMethod,
                                 chain: Chain,
                                 network: Network,
                                 api: AlchemyAPI,
                                 requests: [String: String] = [:],
                                 pathComponents: [String] = [],
                                 queryParameters: [URLQueryItem] = [],
                                 requestBody: [String: Any] = [:])
    throws -> URLRequest {
        
        let urlString = self.builUrlString(chain: chain,
                                           network: network,
                                           api: api,
                                           requests: requests,
                                           pathComponents: pathComponents,
                                           queryParameters: queryParameters)
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = requests
        
        urlRequest.addValue(acceptKey, forHTTPHeaderField: headerFieldContentTypeKey)
        
        switch method {
        case .get:
            break
        case .post:
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        }
        
        return urlRequest
    }
    
    func builUrlString(chain: Chain,
                       network: Network,
                       api: AlchemyAPI,
                       requests: [String: String] = [:],
                       pathComponents: [String] = [],
                       queryParameters: [URLQueryItem] = [])
    -> String {
        let chainAndNetwork: String = chain.rawValue + "-" + network.rawValue
        var urlString = String(format: self.baseUrl, chainAndNetwork)
        let apiVersion = "v2"
        
        switch api {
        case .transfers:
            break
        default:
            urlString += ("/" + "nft")
        }

        urlString += ("/" + apiVersion + "/" + EnvironmentConfig.alchemyAPIKey)
        
        if let endpoint = api.endpoint {
            urlString += ("/" + endpoint)
        }
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                urlString += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            urlString += "?"
            let argumentString = queryParameters.compactMap {
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            
            urlString += argumentString
        }

        return urlString
    }
}

extension AlchemyServiceManager {
    enum AlchemyServiceError: Error {
        case wrongRequest
    }
}
