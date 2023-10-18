//
//  OwnedNFTs.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/04.
//

import Foundation

enum NFTType {
    case idCard
    case coupon
}

enum AttributeTraitType: String {
    case position
    case yearOfEntry = "year of entry"
    case name
}

struct OwnedNFTs: Codable {
    let ownedNfts: [OwnedNFT]
    let pageKey: String?
    let totalCount: Int
}

struct OwnedNFT: Codable {
    let contract: Contract
    let id: NFTId
    let title: String
    let description: String
    let metadata: NFTMetadata
}

struct Contract: Codable {
    let address: String
}

struct NFTId: Codable {
    let tokenId: String
}

struct NFTMetadata: Codable {
    let image: String?
    let name: String?
    let description: String?
    let attributes: [NFTAttribute]?
    let tokenId: Int?
    let contractMetadata: ContractMetadata?
}

struct NFTAttribute: Codable {
    let value: String
    let traitType: String
}

struct ContractMetadata: Codable {
    let name: String
    let symbol: String
    let tokenType: String
}

struct IdCardInfo: Codable {
    let tier: Int64
    let idCard: OwnedNFT
}

struct IdCardInfoMetadata: Codable {
    let tier: Int64
    let idCard: NFTMetadata?
}
