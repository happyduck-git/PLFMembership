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
            self.coupon = await self.getCoffeeCoupon(tokenId: tokenId)
            
            self.isLoaded = true
        }
    }
}

extension MyCouponDetailViewViewModel {
    
    func reclaimCoupon(tokenId: Int64) async -> Bool {
        do {
            let results = try await nftServiceManager.reclaimCoupon(from: MainConstants.userAddress,
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
    
    /// Get Coffee Coupon Infomation.
    /// - Parameter tokenId: Token id of the coffee coupon nft.
    private func getCoffeeCoupon(tokenId: Int64) async -> CoffeeCoupon? {
        do {
            let urlString = await AlchemyServiceManager.shared.builUrlString(chain: .polygon,
                                                                             network: .mumbai,
                                                                             api: .transfers)
            guard let url = URL(string: urlString) else {
                PLFLogger.logger.error("Error converting url string to url.)")
                return nil
            }
            
            let client = EthereumHttpClient(url: url)
            let contract = CoffeeNFTContract(contract: EnvironmentConfig.coffeeCouponContractAddress, client: client)
            
            let result = try await contract.getCoffeeCoupon(tokenId: BigUInt(tokenId))
            
            return self.decodeJSON(from: result)
        }
        catch {
            PLFLogger.logger.error("Error get coffee function -- \(String(describing: error))")
            return nil
        }
        
    }
    
    private func decodeJSON(from jsonString: String) -> CoffeeCoupon? {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let coupon = try decoder.decode(CoffeeCoupon.self, from: jsonData)
                return coupon
            } catch {
                PLFLogger.logger.error("Error decoding JSON: \(String(describing: error))")
            }
        }
        return nil
    }

}

extension MyCouponDetailViewViewModel {
    enum Web3SwiftError: Error {
        case wrongUrl
    }
}
