//
//  DiscoverTableViewCell.swift
//  PLFMembership
//
//  Created by Platfarm on 10/11/23.
//

import UIKit
import Nuke
import SnapKit
import Combine

enum DiscoverType: String {
    case used
    case newMember
    case newCoupon
    case poap
    
    var description: String {
        switch self {
        case .used:
            return "Special coffee in Gangnam Blue Bottle Cafe."
        case .newMember:
            return "🎉 New member just joined!"
        case .newCoupon:
            return "Coffee coupon just got delivered!"
        case .poap:
            return "Celebrate your new poap!"
        }
    }
}

final class DiscoverTableViewCell: UITableViewCell {
    
    @Published var likeCount: Int = 0
    @Published var isLiked: Bool = false
    
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    private let imageContainerView: UIView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let discoverButtonView: DiscoverButtonView = {
        let view = DiscoverButtonView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let contentsContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileComponentsView: DiscoverUserProfileView = {
        let view = DiscoverUserProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tokenIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = PLFColor.darkGray
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let filledHeartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .heartRed)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let numberOfLikesLabel: UILabel = {
        let label = UILabel()
        label.text = String(describing: 0)
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomButtonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let likeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(resource: .heartEmpty), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let shareButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(resource: .share), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Configure
extension DiscoverTableViewCell {
    func configure(type: DiscoverType, vm: TransferInfo) {
        
        self.tokenIdLabel.text = "Token ID #\(String(describing: vm.transfer.erc721TokenId?.removeHexPrefixAndLeadingZeros() ?? "NAT"))"
        
        self.descriptionLabel.text = type.description
        
        var nftImage: String = ""
        switch type {
        case .used:
            self.discoverButtonView.configure(image: UIImage(resource: .demoCoffee))
        case .newMember, .newCoupon, .poap:
            nftImage = vm.image
        }
        
        if let url = URL(string: vm.image) {
            Task {
                var image: UIImage?
                
                do {
                    image = try await ImagePipeline.shared.image(for: url)
                }
                catch {
                    image = UIImage(resource: .g3LogoBig)
                    PLFLogger.logger.error("Error loading image using Nuke -- \(String(describing: error))")
                }
                
                switch type {
                case .used:
                    self.discoverButtonView.isHidden = false
                    self.nftImageView.isHidden = true
                    self.discoverButtonView.configure(image: image)
                    
                case .newMember, .newCoupon, .poap:
                    self.discoverButtonView.isHidden = true
                    self.nftImageView.isHidden = false
                    self.nftImageView.image = image
                }
 
                self.profileComponentsView.configure(image: image,
                                                     username: vm.transfer.to,
                                                     time: vm.transfer.metadata.blockTimestamp)
                
            }
            
        }
        
    }
    
    func bind() {
        
        self.bindings.forEach { $0.cancel() }
        self.bindings.removeAll()
        
        func bindViewToViewModel() {
            self.likeButton.tapPublisher
                .sink { [weak self] _ in
                    guard let `self` = self else { return }
                    self.likeCount += self.isLiked ? -1 : 1
                    self.isLiked.toggle()
                }
                .store(in: &bindings)
        }
        
        func bindViewModelToView() {
            self.$likeCount
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    guard let `self` = self else { return }
                    
                    self.numberOfLikesLabel.text = String(describing: $0)
                }
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
        
    }
}

extension DiscoverTableViewCell {
    override func prepareForReuse() {
        self.discoverButtonView.isHidden = true
        self.nftImageView.isHidden = false
    }
    
    func resetCell() {
        self.profileComponentsView.configure(image: nil,
                                             username: " ",
                                             time: " ")
        self.numberOfLikesLabel.text = nil
    }
}

// MARK: - Set UI & Layout
extension DiscoverTableViewCell {
    private func setUI() {
        self.contentView.addSubviews(self.imageContainerView,
                                     self.contentsContainerView)
        
        self.imageContainerView.addSubviews(self.discoverButtonView,
                                            self.nftImageView)
        
        self.contentsContainerView.addSubviews(self.profileComponentsView,
                                               self.tokenIdLabel,
                                               self.descriptionLabel,
                                               self.likesStack,
                                               self.bottomButtonStack)
    
        self.likesStack.addArrangedSubviews(self.filledHeartImage,
                                            self.numberOfLikesLabel)
        
        self.bottomButtonStack.addArrangedSubviews(self.likeButton,
                                                   self.shareButton)
    }
    
    private func setLayout() {
        self.imageContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.contentView)
            $0.height.equalTo(300) //temp
        }
        
        self.discoverButtonView.snp.makeConstraints {
            $0.centerX.equalTo(self.contentView)
        }
        
        self.nftImageView.snp.makeConstraints {
            $0.centerX.equalTo(self.contentView)
            $0.top.leading.equalTo(self.imageContainerView).offset(20)
            $0.bottom.trailing.equalTo(self.imageContainerView).offset(-20)
        }
        
        self.contentsContainerView.snp.makeConstraints {
            $0.top.equalTo(self.imageContainerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.contentView)
        }
        
        self.profileComponentsView.snp.makeConstraints {
            $0.top.equalTo(self.contentsContainerView).offset(10)
            $0.leading.equalTo(self.contentsContainerView).offset(20)
            $0.trailing.equalTo(self.contentsContainerView).offset(-20)
            $0.height.equalTo(40)
        }
        
        self.tokenIdLabel.snp.makeConstraints {
            $0.top.equalTo(self.profileComponentsView.snp.bottom).offset(10)
            $0.leading.equalTo(self.profileComponentsView.snp.leading)
        }
        
        self.descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.tokenIdLabel.snp.bottom)
            $0.leading.equalTo(self.profileComponentsView.snp.leading)
        }
        
        self.likesStack.snp.makeConstraints {
            $0.leading.equalTo(self.profileComponentsView)
            $0.bottom.equalTo(self.contentView).offset(-10)
        }
        
        self.bottomButtonStack.snp.makeConstraints {
            $0.trailing.equalTo(self.contentsContainerView.snp.trailing).offset(-20)
            $0.bottom.equalTo(self.likesStack.snp.bottom)
        }
    }
}
