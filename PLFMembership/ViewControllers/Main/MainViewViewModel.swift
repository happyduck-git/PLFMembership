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
        
        $idCardNft.sink { nfts in
            print("Results: \(nfts)")
        }
        .store(in: &bindings)
    }
}

extension MainViewViewModel {
    private func getIdCardNft() async throws {
        let result = try await AlchemyServiceManager
            .shared
            .requestOwnedNFTs(
                ownerAddress: MainConstants.userAddress,
                contractAddresses: EnvironmentConfig.sbtContractAddress
            )
        
//        print("Result: \(result.ownedNfts)")
        self.idCardNft = result.ownedNfts
    }
}
