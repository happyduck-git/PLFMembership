//
//  MyNFTDetailViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/04.
//

import UIKit
import Nuke

final class MyNFTDetailViewController: BaseScrollViewController {

    // MARK: - View Model
    private let vm: MyNFTDetailViewViewModel
    
    // MARK: - UI Elements
    private let nftBgView: UIView = {
        let view = UIView()
        view.backgroundColor = PLFColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 8.0
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
       
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init
    init(vm: MyNFTDetailViewViewModel) {
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
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.badge.layer.cornerRadius = self.badge.frame.height / 2
    }

}

extension MyNFTDetailViewController {
    private func configure() {
        let name = vm.nft.metadata.name ?? "Name"
        self.nftNameLabel.text = name
        
        self.vm.detailInfoList.forEach { info in
            
            let view = TraitDetailView()
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
            case .attributes:
                value = "\(vm.nft.metadata.attributes ?? [])"
            }
            
            
            view.configure(title: info.rawValue, value: value)
            
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

extension MyNFTDetailViewController {
    private func setUI() {
        self.view.addSubviews(self.nftBgView,
                              self.titleContainer,
                              self.detailsContainer)
        
        self.nftBgView.addSubview(self.nftImageView)
        
        self.titleContainer.addSubviews(self.badge,
                                        self.nftNameLabel)
        
        self.detailsContainer.addSubviews(self.detailTitle,
                                          self.detailStack)
    }
    
    private func setLayout() {
        self.nftBgView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.canvasView)
            $0.height.equalTo(self.view.snp.height).multipliedBy(1.0/3.0)
        }
        
        self.nftImageView.snp.makeConstraints {
            let vGap: CGFloat = 40
            
            $0.top.equalTo(self.nftBgView.snp.top).offset(vGap)
            $0.bottom.equalTo(self.nftBgView.snp.bottom).offset(-vGap)
            $0.centerX.equalTo(self.canvasView)
            $0.width.equalTo(self.nftImageView.snp.height)
        }
        
        self.titleContainer.snp.makeConstraints {
            $0.top.equalTo(self.nftBgView.snp.bottom)
            $0.leading.trailing.equalTo(self.nftBgView)
            $0.height.equalTo(106)
        }
        
        self.badge.snp.makeConstraints {
            $0.top.leading.equalTo(self.titleContainer).offset(20)
        }
        
        self.nftNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.badge.snp.bottom).offset(4)
            $0.leading.equalTo(self.badge)
            $0.bottom.equalTo(self.titleContainer).offset(-20)
        }
        
        self.detailsContainer.snp.makeConstraints {
            $0.top.equalTo(self.titleContainer.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalTo(self.canvasView)
        }
        
        self.detailTitle.snp.makeConstraints {
            $0.top.equalTo(self.detailsContainer.snp.top).offset(23)
            $0.leading.equalTo(self.detailsContainer).offset(20)
        }
        
        self.detailStack.snp.makeConstraints {
            $0.top.equalTo(self.detailTitle.snp.bottom).offset(20)
            $0.leading.equalTo(self.detailsContainer).offset(20)
            $0.trailing.bottom.equalTo(self.detailsContainer).offset(-20)
        }
    }
}