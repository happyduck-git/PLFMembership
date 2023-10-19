//
//  MyNFTsViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import Foundation
import Combine

final class MyNFTsViewViewModel {
    
    // MARK: - Property
    @Published var idCardNft: [OwnedNFT] = []
    
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Init
    init(mainViewModel: MainViewViewModel) {
        
        mainViewModel.$ownedNFTs
            .assign(to: &self.$idCardNft)

        Task {
            self.idCardNft.append(contentsOf: await getOtherNft())
        }
    }
    
    private func getOtherNft() async -> [OwnedNFT] {
        do {
            let result = try await AlchemyServiceManager
                .shared
                .requestOwnedNFTs(
                    ownerAddress: MainConstants.userAddress,
                    contractAddresses: EnvironmentConfig.poapCouponContractAddress
                )
            print("\(result.ownedNfts.count) -- \(result.ownedNfts)")
            return result.ownedNfts
        }
        catch {
            PLFLogger.logger.error("Error getting owned id card nft -- \(String(describing: error))")
            return []
        }

    }
}

