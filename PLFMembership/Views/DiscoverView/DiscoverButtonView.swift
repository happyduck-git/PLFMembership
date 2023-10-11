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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let yesBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("💛 YES 💛", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let noBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Not for me", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DiscoverButtonView {
    
}
