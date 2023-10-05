//
//  CoffeeCoupon.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import Foundation

struct CoffeeCoupon: Decodable {
    let code: String
    let endOfDate: String
    let price: String
    let brandName: String
}
