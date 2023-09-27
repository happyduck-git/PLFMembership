//
//  SideMenuViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/26.
//

import Foundation

final class SideMenuViewViewModel {
    
    enum MenuType: Int, CaseIterable {
        case home
        case myNfts
    }
    
    private let menuList: [MenuType: String] = [
        .home: ImageAssets.starFill,
        .myNfts: ImageAssets.starFill
    ]
    
    func numberOfMenu() -> Int {
        return menuList.count
    }
    
    func getMenu(of section: Int) -> (title: String, image: String) {
        
        let type = MenuType.allCases.filter {
            $0.rawValue == section
        }.first
        
        guard let sectionType = type else {
            return ("no menu", "no image")
        }
        
        var key: String = ""
        switch type {
        case .home:
            key = SideMenuConstants.home
        case .myNfts:
            key = SideMenuConstants.myNfts
        default:
            key = SideMenuConstants.myNfts
        }
        
        return (key, self.menuList[sectionType] ?? "n/a")
    }
}

