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
        stack.spacing = 5.0
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let nftType: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
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
    func configure(with nft: OwnedNFT) {
        self.nftType.text = nft.metadata.name ?? "Nft Name"
        
        var name: String = ""
        nft.metadata.attributes?.forEach({ att in
            if AttributeTraitType(rawValue: att.traitType) == .name {
                
            }
        })
        self.title.text = nft.metadata.description ?? "Title"
        
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
            $0.top.equalTo(self.nftImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(self.nftImageView)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
    }
}
