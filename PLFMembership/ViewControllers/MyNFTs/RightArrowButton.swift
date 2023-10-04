//
//  RightArrowButton.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/04.
//

import UIKit

final class RightArrowButton: UIButton {

    // MARK: - UI Elements
    private let title: UILabel = {
        let label = UILabel()
        label.text = MyNftsConstants.ownedCoupons
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let buttonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageAssets.arrowRight)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = PLFColor.buttonBlue
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Set UI & Layout
extension RightArrowButton {
    
    private func setUI() {
        self.addSubviews(self.title,
                         self.buttonImage)
    }
    
    private func setLayout() {
        self.title.snp.makeConstraints {
            $0.top.equalTo(self).offset(8)
            $0.leading.equalTo(self).offset(20)
            $0.bottom.equalTo(self).offset(-8)
        }
        
        self.buttonImage.snp.makeConstraints {
            $0.top.equalTo(self).offset(8)
            $0.leading.equalTo(self.title.snp.trailing).offset(8)
            $0.bottom.equalTo(self).offset(-8)
            $0.trailing.equalTo(self).offset(-20)
            $0.width.equalTo(self.buttonImage.snp.height)
        }
        
    }
    
}
