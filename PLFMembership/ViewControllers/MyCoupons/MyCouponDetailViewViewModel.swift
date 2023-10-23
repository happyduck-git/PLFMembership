//
//  MyCouponDetailViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import Foundation
import BigInt
import web3
import Combine

final class MyCouponDetailViewViewModel {
    
    private let nftServiceManager = NFTServiceManager.shared
    private let web3Manager = Web3Manager.shared
    
    private(set) var nft: OwnedNFT
    @Published var coupon: CoffeeCoupon?
    @Published var isLoaded: Bool = false
    
    let detailInfoList: [DetailInfo] = DetailInfo.allCases
    
    enum DetailInfo: String, CaseIterable {
        case expiredBy = "유효기간"
        case venue = "사용처"
        case price = "사용가능 금액"
        case tokenId = "토큰 ID"
        case contractAddress = "컨트랙트 주소"
        case tokenStandard = "토큰 스탠다드"
        case chain = "체인"
        
        var tag: Int {
            switch self {
            case .expiredBy:
                return 0
            case .venue:
                return 1
            case .price:
                return 2
            case .tokenId:
                return 3
            case .contractAddress:
                return 4
            case .tokenStandard:
                return 5
            case .chain:
                return 6
            }
        }
    }
    
    // MARK: - Init
    init(nft: OwnedNFT) {
        self.nft = nft
        
        Task {
            guard let tokenId = nft.id.tokenId.hexStringToInt64() else { return }
            self.coupon = await self.web3Manager.getCoffeeCoupon(tokenId: tokenId)
            
            self.isLoaded = true
        }
    }
}

extension MyCouponDetailViewViewModel {
    
    func reclaimCoupon(tokenId: Int64) async -> Bool {
        do {
            let results = try await nftServiceManager.reclaimCoupon(from: MainConstants.tbaAddress,
                                                                    tokenId: tokenId)
            print("Transfer status code: \(results.statusCode)")
            return results.success
            
        }
        catch {
            PLFLogger.logger.error("Error request to reclaim a coupon. -- \(String(describing: error))")
            return false
        }
    }
    
}

extension MyCouponDetailViewViewModel {
    enum Web3SwiftError: Error {
        case wrongUrl
    }
}
