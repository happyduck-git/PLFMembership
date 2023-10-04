//
//  MyNFTsViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/26.
//

import UIKit

final class MyNFTsViewController: BaseViewController {
    
    
    private let numberOfNftsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "총 0개"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nftCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let showCouponsButton: RightArrowButton = {
        let btn = RightArrowButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 8.0
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        self.setUI()
        self.setLayout()
        self.setNavigationBar()
        
    }
    
}

// MARK: - Set UI
extension MyNFTsViewController {
    
    private func setUI() {
        self.view.addSubviews(self.numberOfNftsLabel,
                              self.nftCollection,
                              self.showCouponsButton)
    }
    
    private func setLayout() {
        self.numberOfNftsLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        
        self.nftCollection.snp.makeConstraints {
            $0.top.equalTo(self.numberOfNftsLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(self.numberOfNftsLabel)
        }
        
        self.showCouponsButton.snp.makeConstraints {
            $0.top.equalTo(self.nftCollection.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.nftCollection)
            $0.height.equalTo(48)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func setNavigationBar() {
        self.parent?.title = "나의 NFT"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
