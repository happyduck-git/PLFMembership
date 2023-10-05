//
//  MainViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/26.
//

import UIKit
import Combine

final class MainViewViewModel {
    
    // MARK: - Property
    @Published var idCardNft: [OwnedNFT] = []
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        Task {
            try await self.getIdCardNft()
        }
    }
    
}

extension MainViewViewModel {
    private func getIdCardNft() async throws {
        do {
            let result = try await AlchemyServiceManager
                .shared
                .requestOwnedNFTs(
                    ownerAddress: MainConstants.userAddress,
                    contractAddresses: EnvironmentConfig.sbtContractAddress
                )
            
            self.idCardNft = result.ownedNfts
        }
        catch {
            PLFLogger.logger.error("Error getting owned id card nft -- \(String(describing: error))")
        }

    }
}
