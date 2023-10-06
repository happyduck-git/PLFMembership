//
//  MainViewViewModel.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/26.
//

import UIKit
import Combine

final class MainViewViewModel {
    
    // MARK: - Property
    @Published var idCardNft: [OwnedNFT] = []
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        Task {
            try await self.getIdCardNft()
        }
    }
    
}

extension MainViewViewModel {
    private func getIdCardNft() async throws {
        do {
            let result = try await AlchemyServiceManager
                .shared
                .requestOwnedNFTs(
                    ownerAddress: MainConstants.userAddress,
                    contractAddresses: EnvironmentConfig.sbtContractAddress
                )
            
            self.idCardNft = result.ownedNfts
        }
        catch {
            PLFLogger.logger.error("Error getting owned id card nft -- \(String(describing: error))")
        }

    }
}

extension MainViewViewModel {
    func yearsAndMonthsPassed(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let startDate = dateFormatter.date(from: dateString) else {
            return nil // Invalid date string
        }

        let calendar = Calendar.current

        // Calculate the difference in years and months
        let dateComponents = calendar.dateComponents([.year, .month], from: startDate, to: Date())

        let years = dateComponents.year ?? 0
        let months = dateComponents.month ?? 0

        if years == 0 {
            return "\(months)개월"
        } else {
            return "\(years)년 \(months)개월"
        }
        
    }

}
