//
//  DiscoverTableViewCellViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 10/12/23.
//

import Foundation
import Combine

final class DiscoverTableViewCellViewModel {
    @Published var likeCount: Int = 0
    @Published var isLiked: Bool = false
}
