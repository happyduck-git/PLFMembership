//
//  TxHistoryViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import Foundation
import Combine

final class TxHistoryViewViewModel {
    
    private let alchemyManager = AlchemyServiceManager.shared
    
    @Published var nftButtonTapped: Bool = true
    @Published var couponButtonTapped: Bool = false
    
    @Published var nftTransferHistoryList: [Transfer] = []
    @Published var couponTransferHistoryList: [Transfer] = []
    
    // MARK: - Init
    init() {
        self.getTransferHistory()
    }
    
}

extension TxHistoryViewViewModel {
    
    private func getTransferHistory() {
        Task {
            do {
                async let sbtTransfers = self.alchemyManager.requestSBTTransfers()
//                async let couponTransfers = self.alchemyManager.requestCouponTransfers()

                async let couponTransfers = self.alchemyManager.requestCouponTransfersCombined()
                
                self.nftTransferHistoryList = try await sbtTransfers.result.transfers
//                self.couponTransferHistoryList = try await couponTransfers.result.transfers
 
                self.couponTransferHistoryList = try await couponTransfers
                
                
//                await withTaskGroup(of: TransferInfo.self, body: { tg in
//                    tg.addTask {
//                        try await self.alchemyManager.builUrlString(chain: <#T##AlchemyServiceManager.Chain#>, network: <#T##AlchemyServiceManager.Network#>, api: <#T##AlchemyServiceManager.AlchemyAPI#>)
//                    }
//                })
             
                
            }
            catch {
                PLFLogger.logger.error("Error requesting SBT Transfer history -- \(String(describing: error))")
            }
            
        }
    }
}
