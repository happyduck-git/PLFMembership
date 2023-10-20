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


final class MyCouponDetailViewController: BaseScrollViewController {
    
    // MARK: - View Model
    private let vm: MyCouponDetailViewViewModel
    
    // MARK: - Combine
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    private let loadingVC = LoadingViewController()
    
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
        view.backgroundColor = PLFColor.gray01
        view.title.text = MyNftsConstants.coffee
        
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 2
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
        label.text = String(localized: "상세 정보")
        label.textColor = PLFColor.darkGray
        label.font = .systemFont(ofSize: 18, weight: .bold)
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
    
    private let usedButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(String(localized: "사용 완료"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = PLFColor.mint03
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 8.0
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
        
        self.baseDelegate = self
        
        self.bind()
        
        self.addChildViewController(self.loadingVC)
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
            self.usedButton.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let `self` = self else { return }
                    
                    self.showAlert(alertTitle: String(localized: "사용 완료 보내기"),
                                   alertMessage: String(localized: "쿠폰 사용 완료 하시겠습니까?"),
                                   alertStyle: .alert,
                                   actionTitle1: String(localized: "확인"),
                                   actionStyle1: .cancel,
                                   actionTitle2: String(localized: "취소"),
                                   actionStyle2: .default)
                    
                }
                .store(in: &bindings)
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
            
            self.vm.$isLoaded
                .receive(on: DispatchQueue.main)
                .sink { [weak self] loaded in
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
                value = vm.nft.id.tokenId
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
        self.canvasView.addSubviews(self.nftImageView,
                                    self.badge,
                                    self.nftNameLabel,
                                    self.barcodeImageView,
                                    self.detailsContainer,
                                    self.usedButton)
        
        self.detailsContainer.addSubviews(self.detailTitle,
                                          self.detailStack)
    }
    
    private func setLayout() {
        
        self.nftImageView.snp.makeConstraints {
            $0.top.equalTo(self.canvasView).offset(24)
            $0.leading.equalTo(self.canvasView).offset(20)
            $0.height.width.equalTo(160)
        }
        
        self.badge.snp.makeConstraints {
            $0.top.equalTo(self.nftImageView)
            $0.leading.equalTo(self.nftImageView.snp.trailing).offset(20)
            $0.width.greaterThanOrEqualTo(60)
        }
        
        self.nftNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.badge.snp.bottom).offset(4)
            $0.leading.equalTo(self.badge)
            $0.trailing.equalTo(self.view).offset(-20)
        }
        
        self.barcodeImageView.snp.makeConstraints {
            $0.top.equalTo(self.nftImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(self.canvasView.snp.centerX)
            $0.height.equalTo(150)
            $0.width.equalTo(210)
        }
        
        self.detailsContainer.snp.makeConstraints {
            $0.top.equalTo(self.barcodeImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(self.canvasView)
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
        
        self.usedButton.snp.makeConstraints {
            $0.top.equalTo(self.detailsContainer.snp.bottom).offset(20)
            $0.leading.equalTo(self.canvasView.snp.leading).offset(20)
            $0.trailing.equalTo(self.canvasView.snp.trailing).offset(-20)
            $0.height.equalTo(50)
            $0.bottom.equalTo(self.canvasView.snp.bottom).offset(-20)
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

extension MyCouponDetailViewController: BaseViewControllerDelegate {
    func firstBtnTapped() {
        self.addChildViewController(self.loadingVC)
        
        Task {
            let tokenId = Int64(self.vm.nft.id.tokenId.dropFirst(2)) ?? 0
            let result = await self.vm.reclaimCoupon(tokenId: tokenId)
            print("Result: \(result)")
        }
    
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.loadingVC.removeViewController()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func secondBtnTapped() {
        
    }
}
