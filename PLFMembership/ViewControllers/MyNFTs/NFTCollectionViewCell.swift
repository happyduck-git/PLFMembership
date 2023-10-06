//
//  NFTCollectionViewCell.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/04.
//

import UIKit
import SnapKit
import Nuke

final class NFTCollectionViewCell: UICollectionViewCell {
    
    enum NFTType {
        case idCard
        case coupon
    }
    
    // MARK: - UI Elements
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let nftType: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure
extension NFTCollectionViewCell {
    func configure(cellType: NFTType, with nft: OwnedNFT) {
        self.nftType.text = nft.metadata.name ?? "Nft Name"
        
        var name: String = ""
        switch cellType {
        case .idCard:
            nft.metadata.attributes?.forEach({ att in
                if AttributeTraitType(rawValue: att.traitType) == .name {
                    name = att.value
                }
            })
        case .coupon:
            name = "#" + self.removeHexPrefixAndLeadingZeros(from: nft.id.tokenId)
        }
        
        self.title.text = name
        
        guard let imageUrlString = nft.metadata.image,
              let imageUrl = URL(string: imageUrlString) else {
            
            self.nftImageView.image = UIImage(named: ImageAssets.g3LogoBig)
            return
        }
        
        Task {
            do {
                self.nftImageView.image = try await ImagePipeline.shared.image(for: imageUrl)
            }
            catch {
                PLFLogger.logger.error("Error fetching \(String(describing: error))")
            }
        }
        
    }
}

// MARK: - Set UI
extension NFTCollectionViewCell {
    private func setUI() {
        self.contentView.addSubviews(self.nftImageView,
                                     self.titleStack)
        
        self.titleStack.addArrangedSubviews(self.nftType,
                                            self.title)
    }
    
    private func setLayout() {
        self.nftImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.contentView)
            $0.height.equalTo(self.nftImageView.snp.width)
        }
        
        self.titleStack.snp.makeConstraints {
            $0.top.equalTo(self.nftImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.nftImageView)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
    }
}

// MARK: - Private
extension NFTCollectionViewCell {
    func removeHexPrefixAndLeadingZeros(from hexString: String) -> String {
        // Remove the "0x" prefix if it exists
        let stringWithoutPrefix = hexString.hasPrefix("0x") ? String(hexString.dropFirst(2)) : hexString
        
        // Remove leading zeros
        let result = stringWithoutPrefix.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
        
        return result.isEmpty ? "0" : result
    }
}
