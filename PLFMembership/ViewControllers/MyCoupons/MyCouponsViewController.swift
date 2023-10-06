//
//  MyCouponsViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import UIKit
import Combine

final class MyCouponsViewController: BaseViewController {
    
    // MARK: - View Model
    private let vm: MyCouponsViewViewModel
    
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
    
    private let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = PLFColor.gray01
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .bell)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "쿠폰 사용 안내"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoDesc: TraitDetailView = {
       let view = TraitDetailView()
        view.configure(title: "사용방법", value: "쿠폰 사용 후 \"사용완료\" 버튼을 눌러주세요.")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    init(vm: MyCouponsViewViewModel) {
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
        
        self.setDelegate()
        self.setUI()
        self.setLayout()
        self.setNavigationBar()
        
        self.bind()
    }
    
}

// MARK: - Binding with VM
extension MyCouponsViewController {
    
    private func bind() {
        func bindViewToViewModel() {
            
        }
        func bindViewModelToView() {
            self.vm.$couponNft
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

// MARK: - Set UI
extension MyCouponsViewController {
    
    private func setDelegate() {
        self.nftCollection.delegate = self
        self.nftCollection.dataSource = self
    }
    
    private func setUI() {
        self.view.addSubviews(self.numberOfNftsLabel,
                              self.nftCollection,
                              self.infoContainer)
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
        
        self.infoContainer.snp.makeConstraints {
            $0.top.equalTo(self.nftCollection.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(self.view)
            $0.height.equalTo(150)
        }
    }
    
    private func setNavigationBar() {
        self.title = "보유 쿠폰"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

extension MyCouponsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.couponNft.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as? NFTCollectionViewCell else {
            fatalError()
        }
        
        let nft = self.vm.couponNft[indexPath.item]
        cell.configure(with: nft)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.nftCollection.frame.width - 20) / 2
        let height = (self.nftCollection.frame.height - 10) / 2
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = MyCouponDetailViewViewModel(nft: self.vm.couponNft[indexPath.item])
        let vc = MyCouponDetailViewController(vm: vm)
        
        self.show(vc, sender: self)
    }
}
