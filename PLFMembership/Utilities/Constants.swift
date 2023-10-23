//
//  Constants.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/25.
//

import Foundation

struct ImageAssets {
    static let metamaskLogo: String = "metamask"
    static let starFill: String = "star_fill"
    static let hamburgerMenu: String = "hamburger_menu"
    static let clock: String = "clock"
    static let g3Logo: String = "g3_logo"
    static let g3LogoBig: String = "g3_logo_big"
    static let arrowRight: String = "arrowright"
    static let arrowBiDirection: String = "bidirection_arrow"
    static let sparkles: String = "sparkles"
}

struct UIConstant {
    static let buttonRadius: CGFloat = 8.0
}

struct LoginConstant {
    static let metamaskLogin: String = String(localized: "Metamask 로그인하기")
}

struct SideMenuConstants {
    static let home: String = String(localized: "메인 화면")
    static let myNfts: String = String(localized: "나의 NFTs")
    static let discover: String = "Discover"
}

struct MainConstants {
    static var userAddress: String = "0x04dBF23edb725fe9C859908D76E9Ccf38BC80a13" // for debug
    static var tbaAddress: String = "0x37613A45c01e28C0FA36c84Cda6C4ef63e12cb59" // for debug
}

struct MyNftsConstants {
    static let totalNumber: String = String(localized: "총 %d개")
    static let ownedCoupons: String = String(localized: "보유한 쿠폰 보기")
    static let sbt: String = "SBT"
    static let coffee: String = "Coffee"
}

struct UserDefaultsConst {
    static let walletAddress: String = "wallet-address"
    static let tbaAddress: String = "tba-address"
}
