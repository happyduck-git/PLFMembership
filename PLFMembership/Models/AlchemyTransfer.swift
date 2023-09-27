//
//  AlchemyTransfer.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/27.
//

import Foundation

struct AlchemyTransfer: Decodable {
    
    let id: Int
    let result: TransferResult
    let asset: String?
    
    struct TransferResult: Decodable {
        let pageKey: String? 
        let transfers: [Transfer]
    }
 
    struct Transfer: Decodable {
        let category: String
        let erc721TokenId: String?
    }
    
}
