//
//  MainViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/26.
//

import UIKit
import Combine
import web3
import BigInt

final class MainViewViewModel {
    
    private let web3Manager = Web3Manager.shared
    
    // MARK: - Property
    
    @Published var ownedNFTs: [OwnedNFT] = []
    @Published var tier: BigUInt = 0
    @Published var isLoaded: Bool = false
    var isLoading: Bool = false
    @Published var sbtMetadata: NFTMetadata?
    @Published var idCardTokenId: String?
    
    private(set) lazy var ownedIdCard = Publishers.Map(upstream: $ownedNFTs) { [weak self] nfts -> OwnedNFT? in
        guard let `self` = self else { return nil }
        return nfts.first
    }.eraseToAnyPublisher()
    
    private(set) lazy var idCardMetadata = Publishers.CombineLatest($tier, $sbtMetadata)
        .compactMap { tier, metadata -> IdCardInfoMetadata? in
            
            return IdCardInfoMetadata(tier: Int64(tier), idCard: metadata)
        }.eraseToAnyPublisher()
    
    /* Currently Not In Use */
    private(set) lazy var idCardInfo = Publishers.CombineLatest($tier, ownedIdCard)
        .compactMap { tier, idCard -> IdCardInfo? in
            guard let unwrappedIdCard = idCard else { return nil }
            
            return IdCardInfo(tier: Int64(tier), idCard: unwrappedIdCard)
        }.eraseToAnyPublisher()
    
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        Task {
            self.isLoading = true
            
            await self.getUserInfoData(of: MainConstants.userAddress)
            
            self.isLoading = false
            self.isLoaded = true
        }   
    }
    
}


extension MainViewViewModel {
    func getUserInfoData(of address: String) async {
        async let ownedNfts = self.getIdCardNft()
        async let tier = self.web3Manager.getUserTier(address: address)
        
        self.ownedNFTs = await ownedNfts
        self.tier = await tier
    }
}

extension MainViewViewModel {
    
    // MARK: - Get Metadata of a certain tokenId.
    func getMetadata(of tokenId: String) async -> NFTMetadata? {
        
        guard let tokenUri = await self.getTokenUri(of: tokenId),
              let url = URL(string: tokenUri)
        else { return nil }
        
        do {
            return try await NetworkServiceManager.execute(expecting: NFTMetadata.self,
                                                           request: URLRequest(url: url))
        }
        catch {
            return nil
        }
        
    }
    
    // MARK: - Get Token uri.
    private func getTokenUri(of tokenId: String) async -> String? {
        guard let uint = BigUInt(hex: tokenId) else {
            return nil
        }
        return await self.web3Manager.getTokenUri(of: uint)
    }
    
}

extension MainViewViewModel {
    private func getIdCardNft() async -> [OwnedNFT] {
        do {
            let result = try await AlchemyServiceManager
                .shared
                .requestOwnedNFTs(
                    ownerAddress: MainConstants.userAddress,
                    contractAddresses: EnvironmentConfig.sbtContractAddress
                )
            
            return result.ownedNfts
        }
        catch {
            PLFLogger.logger.error("Error getting owned id card nft -- \(String(describing: error))")
            return []
        }

    }
}

// MARK: - Utility
extension MainViewViewModel {
    func yearsAndMonthsPassed(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let startDate = dateFormatter.date(from: dateString) else {
            return nil // Invalid date string
        }

        let calendar = Calendar.current

        // Calculate the difference in years and months
        let dateComponents = calendar.dateComponents([.year, .month], from: startDate, to: Date())

        let years = dateComponents.year ?? 0
        let months = dateComponents.month ?? 0

        if years == 0 {
            return "\(months)개월"
        } else {
            return "\(years)년 \(months)개월"
        }
        
    }

}
