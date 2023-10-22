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
    private let loadingVC = LoadingViewController()
    
    private let numberOfNftsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = String(localized: "총 0개")
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nftCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
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
    
    private let titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 10.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .bell)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = String(localized: "쿠폰 사용 안내")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 10.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let descTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = String(localized: "사용방법")
        label.textColor = PLFColor.gray02
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let descDetail: UILabel = {
        let label = UILabel()
        label.textColor = PLFColor.mint04
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = String(localized: "쿠폰 사용 후 \"사용완료\" 버튼을 눌러주세요.")
        return label
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
        self.setRefreshControl()
        
        self.bind()
        
        self.addChildViewController(self.loadingVC)
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
            
            self.vm.$isLoaded
                .receive(on: DispatchQueue.main)
                .sink {  [weak self] loaded in
                    guard let `self` = self else { return }
                    
                    if loaded {
                        self.loadingVC.removeViewController()
                    }
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
        
        self.infoContainer.addSubviews(self.titleStack,
                                       self.descStack)
        
        self.titleStack.addArrangedSubviews(self.iconImage,
                                            self.infoTitle)
        
        self.descStack.addArrangedSubviews(self.descTitle,
                                            self.descDetail)
        
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
        
        self.titleStack.snp.makeConstraints {
            $0.top.equalTo(self.infoContainer.snp.top).offset(35)
            $0.leading.equalTo(self.infoContainer.snp.leading).offset(20)
            $0.trailing.equalTo(self.infoContainer.snp.trailing).offset(-20)
            $0.width.equalTo(200)
        }
        
        self.iconImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        self.descStack.snp.makeConstraints {
            $0.top.equalTo(self.titleStack.snp.bottom).offset(16)
            $0.leading.equalTo(self.titleStack)
            $0.bottom.equalTo(self.infoContainer.snp.bottom).offset(-20)
            $0.trailing.equalTo(self.infoContainer.snp.trailing).offset(-20)
        }
    }
    
    private func setNavigationBar() {
        self.title = String(localized: "보유 쿠폰")
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setRefreshControl() {
        self.nftCollection.refreshControl = UIRefreshControl()
        self.nftCollection.refreshControl?.tintColor = .gray
        self.nftCollection.refreshControl?.attributedTitle = NSAttributedString(string: String(localized: "커피 쿠폰을 확인하고 있습니다."))
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
        cell.configure(cellType: .coupon, with: nft)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.nftCollection.frame.width - 20) / 2
        let height = (self.nftCollection.frame.height - 10) / 2.3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = MyCouponDetailViewViewModel(nft: self.vm.couponNft[indexPath.item])
        let vc = MyCouponDetailViewController(vm: vm)
        
        self.show(vc, sender: self)
    }
}

extension MyCouponsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -100 && self.vm.isLoaded {
            self.nftCollection.refreshControl?.beginRefreshing()
            
            if self.vm.isLoaded {
                self.vm.isLoaded = false
                Task {
                    await self.vm.getCoupons()
                    self.vm.isLoaded = true
                    DispatchQueue.main.async { [weak self] in
                        guard let `self` = self else { return }
                        self.nftCollection.refreshControl?.endRefreshing()
                    }
                }
            }
            
        }
    }
    
}

