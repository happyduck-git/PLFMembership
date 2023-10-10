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
            async let tier = self.getUserTier(address: MainConstants.userAddress)
            
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

extension MainViewViewModel {
    /// Get SBT tier Infomation.
    /// - Parameter address: Owner's wallet address.
    private func getUserTier(address: String) async -> BigUInt {
        do {
            let urlString = await AlchemyServiceManager.shared.builUrlString(chain: .polygon,
                                                                             network: .mumbai,
                                                                             api: .transfers)
            guard let url = URL(string: urlString) else {
                PLFLogger.logger.error("Error converting url string to url.)")
                return 0
            }
            
            let client = EthereumHttpClient(url: url)
            let contract = IdCardNFTContract(contract: EnvironmentConfig.sbtContractAddress, client: client)
            
            return try await contract.getCurrentUserTier(user: EthereumAddress(address))
        }
        catch {
            PLFLogger.logger.error("Error get coffee function -- \(String(describing: error))")
            return 0
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
