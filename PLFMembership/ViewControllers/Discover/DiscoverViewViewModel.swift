//
//  DiscoverViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 10/12/23.
//

import Foundation
import Combine

final class DiscoverViewViewModel {
    
    private let alchemyManager = AlchemyServiceManager.shared
    
    @Published var isLoaded: Bool = false
    @Published var nftTransferHistoryList: [TransferInfo] = []
    @Published var couponTransferHistoryList: [TransferInfo] = []
    private(set) lazy var transferHistoryList = Publishers.CombineLatest($nftTransferHistoryList, $couponTransferHistoryList).compactMap({
        var txList: [TransferInfo] = []
        txList.append(contentsOf: $0)
        txList.append(contentsOf: $1)
        
        return txList
    }).eraseToAnyPublisher()
    
    var transferHistoryData: [TransferInfo] = []
    var sortedTransferHistoryData: [TransferInfo] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "ko_KR")  // To ensure consistent parsing
        
        let sorted = transferHistoryData.sorted {
            guard let date1 = dateFormatter.date(from: $0.transfer.metadata.blockTimestamp),
                  let date2 = dateFormatter.date(from: $1.transfer.metadata.blockTimestamp) else {
                return false  // If either date string is invalid, just return false
            }
            return date1.compare(date2) == .orderedDescending  // Sort in ascending order
        }

        return sorted
    }
    
    
    // MARK: - Init
    init() {
        Task {
            await self.getTransferHistory()
            self.isLoaded = true
        }
    }
    
}

extension DiscoverViewViewModel {
    
    private func getTransferHistory() async {
            do {
                async let sbtTransfers = self.alchemyManager.requestSBTContractTransfers()
                async let couponTransfers = self.alchemyManager.requestCouponContractTransfers()
                
                let nftTransferList = try await sbtTransfers.result.transfers
                let coupontTransferList = try await couponTransfers
                
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
                    for transfer in coupontTransferList {
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
