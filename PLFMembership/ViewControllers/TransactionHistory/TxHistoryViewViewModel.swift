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
    
    @Published var isLoaded: Bool = false
    @Published var nftButtonTapped: Bool = true
    @Published var couponButtonTapped: Bool = false
    
    @Published var nftTransferHistoryList: [TransferInfo] = []
    @Published var couponTransferHistoryList: [TransferInfo] = []
    
    // MARK: - Init
    init() {
        Task {
            await self.getTransferHistory()
            self.isLoaded = true
        }
        
    }
    
}

extension TxHistoryViewViewModel {
    
    private func getTransferHistory() async {
            do {
                async let sbtTransfers = self.alchemyManager.requestSBTTransfers()
                async let couponTransfers = self.alchemyManager.requestCouponTransfersCombined()
                
                let nftTransferList = try await sbtTransfers.result.transfers
                let coupontTransferList = try await couponTransfers
                
                //SBT Metadata
                self.nftTransferHistoryList = try await withThrowingTaskGroup(of: TransferInfo.self, returning: [TransferInfo].self, body: { tg in
                    for transfer in nftTransferList {
                        tg.addTask {
                            let nft = try await self.alchemyManager.requestNftMetadata(contractAddress: EnvironmentConfig.sbtContractAddress, tokenId: transfer.erc721TokenId ?? "0")
                            let nftName = nft.metadata.name ?? "no-name"
                            
                            return TransferInfo(name: nftName, transfer: transfer)
                        }
                    }
                    
                    var infoList = [TransferInfo]()

                    /// Note the use of `next()`:
                    while let info = try await tg.next() {
                        infoList.append(info)
                    }
                    return infoList
                    
                })
                
                //NFT Metadata
                self.couponTransferHistoryList = try await withThrowingTaskGroup(of: TransferInfo.self, returning: [TransferInfo].self, body: { tg in
                    for transfer in coupontTransferList {
                        tg.addTask {
                            let nft = try await self.alchemyManager.requestNftMetadata(contractAddress: EnvironmentConfig.coffeeCouponContractAddress, tokenId: transfer.erc721TokenId ?? "0")
                            let nftName = nft.metadata.name ?? "no-name"
                            
                            return TransferInfo(name: nftName, transfer: transfer)
                        }
                    }
                    
                    var infoList = [TransferInfo]()

                    /// Note the use of `next()`:
                    while let info = try await tg.next() {
                        infoList.append(info)
                    }
                    return infoList
                    
                })
                
            }
            catch {
                PLFLogger.logger.error("Error requesting SBT Transfer history -- \(String(describing: error))")
            }
            
    }
}
