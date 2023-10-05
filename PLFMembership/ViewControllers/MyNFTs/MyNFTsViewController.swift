//
//  MyNFTsViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/26.
//

import UIKit
import Combine

final class MyNFTsViewController: BaseViewController {
    
    // MARK: - View Model
    private let vm: MyNFTsViewViewModel
    
    // MARK: - Combine
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - UI Elements
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
        collection.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var showCouponsButton: RightArrowButton = {
        let btn = RightArrowButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 8.0
        btn.addTarget(self, action: #selector(showCouponsBtnTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Init
    init(vm: MyNFTsViewViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        self.setUI()
        self.setLayout()
        self.setNavigationBar()
        self.setDelegate()
        
        self.bind()
    }
    
}

// MARK: - Binding with VM
extension MyNFTsViewController {
    
    private func bind() {
        func bindViewToViewModel() {
            
        }
        func bindViewModelToView() {
            self.vm.$idCardNft
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    guard let `self` = self else { return }
      
                    self.numberOfNftsLabel.text = String(format: MyNftsConstants.totalNumber, $0.count)
                    self.nftCollection.reloadData()
                }
                .store(in: &bindings)

        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
}

extension MyNFTsViewController {
    @objc
    private func showCouponsBtnTapped() {
        let vm = MyCouponsViewViewModel()
        let vc = MyCouponsViewController(vm: vm)
        
        self.show(vc, sender: self)
    }
}

// MARK: - Set UI
extension MyNFTsViewController {
    
    private func setDelegate() {
        self.nftCollection.delegate = self
        self.nftCollection.dataSource = self
    }
    
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

extension MyNFTsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.idCardNft.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as? NFTCollectionViewCell else {
            fatalError()
        }
        
        let nft = self.vm.idCardNft[indexPath.item]
        cell.configure(with: nft)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = MyNFTDetailViewViewModel(nft: self.vm.idCardNft[indexPath.item])
        let vc = MyNFTDetailViewController(vm: vm)
        
        self.show(vc, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.nftCollection.frame.width - 20) / 2
        let height = (self.nftCollection.frame.height - 10) / 2
        return CGSize(width: width, height: height)
    }
}
