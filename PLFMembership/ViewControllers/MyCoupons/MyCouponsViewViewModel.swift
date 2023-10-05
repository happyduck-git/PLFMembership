//
//  MyCouponsViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import Foundation

final class MyCouponsViewViewModel {
    
    @Published var couponNft: [OwnedNFT] = []
    
    init() {
        Task {
            await self.getCoupons()
        }
    }
}

extension MyCouponsViewViewModel {
    
    private func getCoupons() async {
        do {
            let result = try await AlchemyServiceManager
                .shared
                .requestOwnedNFTs(
                    ownerAddress: MainConstants.userAddress,
                    contractAddresses: EnvironmentConfig.coffeeCouponContractAddress
                )
            
            self.couponNft = result.ownedNfts
        }
        catch {
            PLFLogger.logger.error("Error getting owned coupon nfts -- \(String(describing: error))")
        }
    }
    
}
