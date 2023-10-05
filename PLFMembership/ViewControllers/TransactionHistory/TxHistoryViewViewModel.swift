//
//  TxHistoryViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import Foundation

final class TxHistoryViewViewModel {
    
    private let alchemyManager = AlchemyServiceManager.shared
    
    init() {
        Task {
            do {
                let rlt = try await alchemyManager.requestSBTTransfers()
                print("Tx result: \(rlt)")
            }
            catch {
                PLFLogger.logger.error("Error requesting SBT Transfer history -- \(String(describing: error))")
            }
            
        }
        
    }
}

extension TxHistoryViewViewModel {
    
}
