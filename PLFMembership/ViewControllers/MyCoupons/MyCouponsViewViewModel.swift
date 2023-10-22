//
//  MyCouponsViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import Foundation

final class MyCouponsViewViewModel {
    
    @Published var couponNft: [OwnedNFT] = []
    @Published var isLoaded: Bool = false
    
    init() {
        Task {
            await self.getCoupons()
            self.isLoaded = true
        }
    }
}

extension MyCouponsViewViewModel {
    
    func getCoupons() async {
        do {
            let result = try await AlchemyServiceManager
                .shared
                .requestOwnedNFTs(
                    ownerAddress: EnvironmentConfig.tbaContractAddress,
                    contractAddresses: EnvironmentConfig.coffeeCouponContractAddress
                )
            
            self.couponNft = result.ownedNfts
        }
        catch {
            PLFLogger.logger.error("Error getting owned coupon nfts -- \(String(describing: error))")
        }
    }
    
}
