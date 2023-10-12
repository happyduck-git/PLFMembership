//
//  DiscoverButtonView.swift
//  PLFMembership
//
//  Created by Platfarm on 10/11/23.
//

import UIKit

final class DiscoverButtonView: UIView {
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .bell)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let btnStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 50
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let yesBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("💛 YES 💛", for: .normal)
        btn.clipsToBounds = true
        btn.backgroundColor = PLFColor.mint03
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let noBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Not for me", for: .normal)
        btn.clipsToBounds = true
        btn.backgroundColor = PLFColor.mint03
        btn.layer.cornerRadius = 8
        return btn
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Configure
extension DiscoverButtonView {
    func configure(image: UIImage?) {
        self.nftImageView.image = image
    }
}

// MARK: - Set UI & Layout
extension DiscoverButtonView {
    
    private func setUI() {
        self.addSubviews(self.nftImageView,
                         self.btnStack)
        
        self.btnStack.addArrangedSubviews(self.yesBtn,
                                          self.noBtn)
    }
    
    private func setLayout() {
        self.nftImageView.snp.makeConstraints {
            $0.top.equalTo(self).offset(20)
            $0.height.equalTo(200)
            $0.leading.equalTo(self).offset(50)
            $0.trailing.equalTo(self).offset(-50)
            $0.centerX.equalTo(self)
        }
        
        self.btnStack.snp.makeConstraints {
            $0.top.equalTo(self.nftImageView.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.bottom.equalTo(self).offset(-20)
            $0.centerX.equalTo(self)
        }
    }
    
}
