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
    @Published var ownedIdCard: OwnedNFT?
    @Published var tier: BigUInt = 0
    @Published var isLoaded: Bool = false
    
    private(set) lazy var idCardInfo = Publishers.CombineLatest($tier, $ownedIdCard)
        .compactMap { tier, idCard -> IdCardInfo? in
            guard let unwrappedIdCard = idCard else { return nil }
            
            return IdCardInfo(tier: Int64(tier), idCard: unwrappedIdCard)
        }.eraseToAnyPublisher()
    
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        Task {
            async let ownedNfts = self.getIdCardNft()
            async let tier = self.web3Manager.getUserTier(address: MainConstants.userAddress)
            
            self.ownedNFTs = await ownedNfts
            self.tier = await tier
            
            self.isLoaded = true
        }   
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
