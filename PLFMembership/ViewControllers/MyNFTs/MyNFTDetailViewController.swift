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
        imageView.layer.borderWidth = 3.0
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
        view.backgroundColor = PLFColor.gray01
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
    
    private let dividerView: UIView = {
       let view = UIView()
        view.backgroundColor = PLFColor.gray01
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        stack.distribution = .equalSpacing
        stack.spacing = 5.0
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
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.badge.layer.cornerRadius = self.badge.frame.height / 2
        
        DispatchQueue.main.async {
            self.nftImageView.setGradientBorder()
        }
        
    }

}

extension MyNFTDetailViewController {
    private func configure() {
        let name = vm.nft.metadata.name ?? "Name"
        self.badge.title.text = name
        
        let tokenId = vm.nft.id.tokenId
        self.nftNameLabel.text = tokenId
        
        self.vm.detailInfoList.forEach { info in
            
            let view = TraitDetailView()
            
            var value: String = ""
            
            switch info {
            case .tokenId:
                value = vm.nft.id.tokenId
            case .contractAddress:                
                value = String(vm.nft.contract.address.prefix(10))
            case .tokenStandard:
                value = vm.nft.metadata.contractMetadata?.tokenType ?? "ERC-721"
            case .chain:
                value = "Polygon" // temp
            case .attributes:
                value = " "
                view.makeTitleTextBold()
            }
            
            view.configure(title: info.rawValue, value: value)
            self.detailStack.addArrangedSubview(view)
            
            if info == .attributes {
                vm.nft.metadata.attributes?.forEach({ ele in
                    let view = TraitDetailView()
                    view.configure(title: ele.traitType, value: ele.value)
                    
                    self.detailStack.addArrangedSubview(view)
                })
                
                let divider = UIView()
                divider.backgroundColor = .gray
                divider.frame.size = CGSize(width: 200, height: 10.0)
                self.detailStack.addArrangedSubview(divider)
            }
            
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
                              self.dividerView,
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
        
        self.dividerView.snp.makeConstraints {
            $0.top.equalTo(self.titleContainer.snp.bottom)
            $0.leading.trailing.equalTo(self.titleContainer)
            $0.bottom.equalTo(self.detailsContainer.snp.top)
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

//#Preview {
//    
//    return MyNFTDetailViewController(vm: MyNFTDetailViewViewModel(nft: OwnedNFT(contract: Contract(address: "0x0000000"),
//                        id: NFTId(tokenId: "0x0000000"), title: "Title", description: "Description", metadata: NFTMetadata(image: nil, name: "Name", description: "desrip", attributes: [NFTAttribute(value: "a", traitType: "trait-a"), NFTAttribute(value: "a", traitType: "trait-a"),NFTAttribute(value: "a", traitType: "trait-a")], tokenId: 1, contractMetadata: ContractMetadata(name: "ContractName", symbol: "ContractSymbol",  tokenType: "Tokentype"))
//                                                                               )
//    )
//    )
//}
