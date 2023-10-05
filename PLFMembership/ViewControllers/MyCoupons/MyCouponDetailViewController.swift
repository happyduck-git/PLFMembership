//
//  MyCouponDetailViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import UIKit
import Nuke
import Combine
import CoreImage.CIFilterBuiltins


final class MyCouponDetailViewController: BaseViewController {

    // MARK: - View Model
    private let vm: MyCouponDetailViewViewModel
 
    // MARK: - Combine
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    private var detailViews: [TraitDetailView] = []
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 8.0
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let badge: TitleBadgeView = {
        let view = TitleBadgeView()
        view.backgroundColor = PLFColor.gray02
        view.title.text = MyNftsConstants.sbt
        
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let barcodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let detailsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let detailTitle: UILabel = {
       let label = UILabel()
        label.text = "상세 정보"
        label.textColor = PLFColor.darkGray
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5.0
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    init(vm: MyCouponDetailViewViewModel) {
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
        self.configure()
        
        self.bind()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.badge.layer.cornerRadius = self.badge.frame.height / 2
    }
    
}

// MARK: - Bind with View Model
extension MyCouponDetailViewController {
    private func bind() {
        func bindViewToViewModel() {
            
        }
        func bindViewModelToView() {
            self.vm.$coupon
                .receive(on: DispatchQueue.main)
                .sink { [weak self] coup in
                    guard let `self` = self,
                          let coupon = coup else {
                        self?.barcodeImageView.backgroundColor = .gray
                        
                        return
                    }
                    
                    self.detailViews.forEach { view in
                        switch view.tag {
                        case 0:
                            view.configureValue(value: coupon.endOfDate)
                        case 1:
                            view.configureValue(value: coupon.brandName)
                        case 2:
                            view.configureValue(value: coupon.price)
                        default:
                            return
                        }
                    }
                    
                    guard let barcodeImage = self.generateBarcode(from: coupon.code) else {
                        self.barcodeImageView.backgroundColor = .gray
                        return
                    }
                    self.barcodeImageView.image = barcodeImage
                    
                }
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
}

// MARK: - Configure
extension MyCouponDetailViewController {
    private func configure() {
        let name = vm.nft.metadata.name ?? "Name"
        self.nftNameLabel.text = name
        
        var tag: Int = 0
        self.vm.detailInfoList.forEach { info in
            
            let view = TraitDetailView()
            
            view.tag = tag
            tag += 1
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            var value: String = ""
            
            switch info {
            case .tokenId:
                value = "\(vm.nft.metadata.tokenId ?? 0)"
            case .contractAddress:
                value = vm.nft.contract.address
            case .tokenStandard:
                value = vm.nft.metadata.contractMetadata?.tokenType ?? "ERC-721"
            case .chain:
                value = "Polygon"
            default:
                value = " "
            }
            
            view.configure(title: info.rawValue, value: value)
            
            self.detailViews.append(view)
            self.detailStack.addArrangedSubview(view)
        }
        
        let imageUrlString = vm.nft.metadata.image ?? "no-image"
        guard let imageUrl = URL(string: imageUrlString) else {
            self.nftImageView.image = UIImage(named: ImageAssets.g3LogoBig)
            return
        }
        Task {
            self.nftImageView.image = try await ImagePipeline.shared.image(for: imageUrl)
        }

    }
}

extension MyCouponDetailViewController {
    private func setUI() {
        self.view.addSubviews(self.nftImageView,
                              self.badge,
                              self.nftNameLabel,
                              self.barcodeImageView,
                              self.detailsContainer)
        
        self.detailsContainer.addSubviews(self.detailTitle,
                                          self.detailStack)
    }
    
    private func setLayout() {

        self.nftImageView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.height.width.equalTo(160)
        }
        
        self.badge.snp.makeConstraints {
            $0.top.equalTo(self.nftImageView)
            $0.leading.equalTo(self.nftImageView.snp.trailing).offset(20)
        }
        
        self.nftNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.badge.snp.bottom).offset(4)
            $0.leading.equalTo(self.badge)
            $0.trailing.equalTo(self.view).offset(-20)
        }
        
        self.barcodeImageView.snp.makeConstraints {
            $0.top.equalTo(self.nftImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.height.equalTo(150)
            $0.width.equalTo(210)
        }
        
        self.detailsContainer.snp.makeConstraints {
            $0.top.equalTo(self.barcodeImageView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.detailTitle.snp.makeConstraints {
            $0.top.equalTo(self.detailsContainer.snp.top).offset(23)
            $0.leading.equalTo(self.detailsContainer).offset(20)
            $0.height.equalTo(50)
        }
        
        self.detailStack.snp.makeConstraints {
            $0.top.equalTo(self.detailTitle.snp.bottom).offset(20)
            $0.leading.equalTo(self.detailsContainer).offset(20)
            $0.trailing.bottom.equalTo(self.detailsContainer).offset(-20)
        }
    }
}

extension MyCouponDetailViewController {
    
    private func generateBarcode(from string: String) -> UIImage? {
        let filter = CIFilter.code128BarcodeGenerator()
        guard let data = string.data(using: .ascii) else {
            return nil
        }
        filter.message = data
        
        if let outputImage = filter.outputImage {
            return UIImage(ciImage: outputImage)
        }
        
        return nil
    }
    
}

