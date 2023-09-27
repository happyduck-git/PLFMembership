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
        static let toAddress = "toAddress"
        static let category = "category"
        static let contractAddresses = "contractAddresses"
        static let getTransferMethod = "alchemy_getAssetTransfers"
        static let erc721 = "erc721"
        static let latest = "latest"
        static let initalBlock = "0x0"
        static let idValue = 1
    }
    
}

extension AlchemyServiceManager {
    
    /// Request SBT Token Transfer History
    /// - Returns: AlchemyTransfer type object of SBT.
    func requestSBTTransfers() async throws -> AlchemyTransfer {
        
        let urlRequest = try self.buildUrlRequest(method: .post,
                                                  chain: .polygon,
                                                  network: .mumbai,
                                                  api: .transfers,
                                                  requestBody: [TransferBodyParam.id: TransferBodyParam.idValue,
                                                                TransferBodyParam.method: TransferBodyParam.getTransferMethod,
                                                                TransferBodyParam.params: [
                                                                    TransferBodyParam.fromBlock: TransferBodyParam.initalBlock,
                                                                    TransferBodyParam.toBlock: TransferBodyParam.latest,
                                                                    TransferBodyParam.category: [TransferBodyParam.erc721],
                                                                    TransferBodyParam.contractAddresses: [EnvironmentConfig.sbtContractAddress]
                                                                ] as [String : Any]
                                                               ])
        
        do {
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
    
    /// Request SBT Token Transfer History
    /// - Returns: AlchemyTransfer type object of coffee coupon.
    func requestCouponTransfers() async throws -> AlchemyTransfer {
        
        let urlRequest = try self.buildUrlRequest(method: .post,
                                                  chain: .polygon,
                                                  network: .mumbai,
                                                  api: .transfers,
                                                  requestBody: [TransferBodyParam.id: TransferBodyParam.idValue,
                                                                TransferBodyParam.method: TransferBodyParam.getTransferMethod,
                                                                TransferBodyParam.params: [
                                                                    TransferBodyParam.fromBlock: TransferBodyParam.initalBlock,
                                                                    TransferBodyParam.toBlock: TransferBodyParam.latest,
                                                                    TransferBodyParam.toAddress: MainConstants.userAddress,
                                                                    TransferBodyParam.category: [TransferBodyParam.erc721],
                                                                    TransferBodyParam.contractAddresses: [EnvironmentConfig.coffeeCouponContractAddress]
                                                                ] as [String : Any]
                                                               ])
        
        do {
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
        
        let urlString = self.builUrlString(method: method,
                                           chain: chain,
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
        
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        return urlRequest
    }
    
    func builUrlString(method: HTTPMethod,
                       chain: Chain,
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
        PLFLogger.logger.info("URLString: \(String(describing: urlString))")
        return urlString
    }
}

extension AlchemyServiceManager {
    enum AlchemyServiceError: Error {
        case wrongRequest
    }
}
