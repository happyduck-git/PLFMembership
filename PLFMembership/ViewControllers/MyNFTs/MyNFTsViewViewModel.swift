//
//  MyNFTsViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import Foundation
import Combine

final class MyNFTsViewViewModel {
    
    // MARK: - Property
    @Published var idCardNft: [OwnedNFT] = []
    
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Init
    init(mainViewModel: MainViewViewModel) {
        
        mainViewModel.$idCardNft
            .assign(to: &self.$idCardNft)

    }
    
}

