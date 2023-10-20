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
                async let sbtTransfers = self.alchemyManager.requestCurrentOwnerSBTTransfers()
                async let couponTransfers = self.alchemyManager.requestCurrentOwnerCouponTransfers()
                
                let nftTransferList = try await sbtTransfers.result.transfers
                let couponTransferList = try await couponTransfers
                
                //SBT Metadata
                self.nftTransferHistoryList = try await withThrowingTaskGroup(of: TransferInfo.self, returning: [TransferInfo].self, body: { tg in
                    for transfer in nftTransferList {
                        tg.addTask {
                            let nft = try await self.alchemyManager.requestNftMetadata(contractAddress: EnvironmentConfig.sbtContractAddress, tokenId: transfer.erc721TokenId ?? "0")
                            let nftName = nft.metadata.name ?? "no-name"
                            let imageUrl = nft.metadata.image ?? "no-image"
                            
                            return TransferInfo(type: .idCard,
                                                name: nftName,
                                                image: imageUrl,
                                                transfer: transfer)
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
                    for transfer in couponTransferList {
                        tg.addTask {
                            let nft = try await self.alchemyManager.requestNftMetadata(contractAddress: EnvironmentConfig.coffeeCouponContractAddress, tokenId: transfer.erc721TokenId ?? "0")
                            let nftName = nft.metadata.name ?? "no-name"
                            let imageUrl = nft.metadata.image ?? "no-image"
                            
                            return TransferInfo(type: .coupon,
                                                name: nftName,
                                                image: imageUrl,
                                                transfer: transfer)
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
