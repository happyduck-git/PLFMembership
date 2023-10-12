//
//  UserProfileView.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/04.
//

import UIKit
import Combine
import SnapKit

protocol UserProfileViewDelegate: AnyObject {
    func g3LogoDidTap()
}

final class UserProfileView: UIView {
    
    // MARK: - Delegate
    weak var delegate: UserProfileViewDelegate?
    
    //MARK: - Combine
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    private let shadowView: PassThroughView = {
        let view = PassThroughView()
        view.backgroundColor = .systemGray4
        view.layer.shadowOpacity = 0.9
        view.layer.shadowRadius = 30.0
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = UIColor.systemGray4.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileContainer: PassThroughView = {
       let view = PassThroughView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.layer.borderWidth = 6.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var g3Button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ImageAssets.g3Logo), for: .normal)
        button.addTarget(self, action: #selector(g3LogoBtnDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let labelStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
        
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.text = " "
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.text = " "
        return label
    }()
    
    private let joinedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.text = " "
        return label
    }()
    
    private let tierLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.text = " "
        return label
    }()
    
    //MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.profileContainer.setGradientBorder()
        }
    }
}

// MARK: - Configure
extension UserProfileView {
    func configure(image: UIImage,
                   position: String,
                   department: String,
                   username: String,
                   joined: String,
                   tier: Int64) {
        
        self.profileImage.image = image
        self.jobLabel.text = position
        self.usernameLabel.text = username
        
        let attributedString = colorAfterPrefix(in: "Platfarm과 함께한지 " + joined, with: PLFColor.mint05)
        self.joinedLabel.attributedText = attributedString
        
        self.tierLabel.text = "Tier#\(tier)"
    }
}

// MARK: - Set UI
extension UserProfileView {
    
    private func setUI() {
        self.addSubviews(self.profileContainer)
        
        self.profileContainer.addSubviews(self.profileImage,
                                          self.g3Button,
                                          self.labelStack,
                                          self.tierLabel)
        
        self.labelStack.addArrangedSubviews(self.jobLabel,
                                            self.usernameLabel,
                                            self.joinedLabel)
        
    }
    
    private func setLayout() {
        self.profileContainer.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalTo(self)
        }
        
        self.profileImage.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.profileContainer)
            $0.height.width.equalTo(268)
        }
        
        self.g3Button.snp.makeConstraints {
            $0.trailing.equalTo(self.profileImage.snp.trailing).offset(-10)
            $0.bottom.equalTo(self.profileImage.snp.bottom).offset(-10)
            $0.width.height.equalTo(30)
        }
        
        self.labelStack.snp.makeConstraints {
            $0.top.equalTo(self.profileImage.snp.bottom).offset(20)
            $0.leading.equalTo(self.profileImage).offset(16)
            $0.trailing.equalTo(self.profileImage).offset(-16)
            $0.bottom.equalTo(self.profileContainer.snp.bottom).offset(-20)
        }

        self.tierLabel.snp.makeConstraints {
            $0.top.equalTo(self.labelStack.snp.top)
            $0.trailing.equalTo(self.profileContainer).offset(-16)
        }
        
        self.jobLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.joinedLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

extension UserProfileView {
    func colorAfterPrefix(in text: String, with color: UIColor) -> NSAttributedString {
        let prefix = "Platfarm과 함께한지 "
        
        let attributedString = NSMutableAttributedString(string: text)
        
        if let range = text.range(of: prefix) {
            let colorRange = NSRange(range.upperBound..<text.endIndex, in: text)
            attributedString.addAttribute(.foregroundColor, value: color, range: colorRange)
        }
        
        return attributedString
    }
}

extension UserProfileView {
    @objc
    private func g3LogoBtnDidTap() {
        self.delegate?.g3LogoDidTap()
    }
}

