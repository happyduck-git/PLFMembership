//
//  NetworkServiceManager.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/27.
//

import Foundation

final actor NetworkServiceManager {
    static func execute<T: Decodable>(expecting type: T.Type,
                                      request: URLRequest) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw URLError(.cannotParseResponse)
        }
        if 200..<300 ~= statusCode {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(type.self, from: data)
        } else {
            PLFLogger.logger.error("Bad status code: \(String(describing: statusCode))")
            throw URLError(.badServerResponse)
        }
        
    }
    
    enum NetworkServiceError: Error {
        case dataError
    }
}
