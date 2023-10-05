//
//  MyNFTDetailViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import Foundation

final class MyNFTDetailViewViewModel {
    
    private(set) var nft: OwnedNFT
    
    let detailInfoList: [DetailInfo] = DetailInfo.allCases
    
    enum DetailInfo: String, CaseIterable {
        case tokenId = "토큰 ID"
        case attributes = "특징"
        case contractAddress = "컨트랙트 주소"
        case tokenStandard = "토큰 스탠다드"
        case chain = "체인"
        
        var key: String {
            switch self {
            case .tokenId:
                return "tokenId"
            case .attributes:
                return "attributes"
            case .contractAddress, .tokenStandard, .chain:
                return "contractMetadata"
            }
        }
    }
    
    // MARK: - Init
    init(nft: OwnedNFT) {
        self.nft = nft
    }
}
