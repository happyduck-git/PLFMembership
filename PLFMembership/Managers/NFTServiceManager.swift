//
//  NFTServiceManager.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/06.
//

import Foundation

/// Singleton Object Class for UPlus NFT Service
final actor NFTServiceManager {
    
    //MARK: - Init
    static let shared = NFTServiceManager()
    private init() {}
    
    //MARK: - URL Constant
    private let baseUrl = "https://its-test.gall3ry.io/nft-infra"
    private let jsonKey = "application/json"
    private let headerFieldAuthorization = "Authorization"
    private let headerFieldContentType = "Content-Type"
    
}

extension NFTServiceManager {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NFTEndPoint: String {
        case reclaim
    }
    
    func reclaimCoupon(from senderAddress: String,
                       tokenId: Int64) async throws -> NFTTransferResponse {
        
        PLFLogger.logger.debug("🫡Request nft transfer: \(tokenId)")
        
        let urlRequest = try self.buildUrlRequest(
            method: .post,
            endPoint: .reclaim,
            pathComponents: ["coffee"],
            requestBody: [
                "from": senderAddress,
                "tokenId": tokenId
            ]
        )
        
        return try await NetworkServiceManager.execute(expecting: NFTTransferResponse.self,
                                                       request: urlRequest)
        
    }
    
}

extension NFTServiceManager {
    private func buildUrlRequest(method: HTTPMethod,
                                 endPoint: NFTEndPoint,
                                 pathComponents: [String] = [],
                                 queryParameters: [URLQueryItem] = [],
                                 requestBody: [String: Any])
    throws -> URLRequest {
        
        var urlString = self.baseUrl + "/" + endPoint.rawValue
        
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
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue(jsonKey, forHTTPHeaderField: headerFieldContentType)
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        return urlRequest
    }

}
