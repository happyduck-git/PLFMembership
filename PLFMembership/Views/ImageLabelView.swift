//
//  ImageLabelView.swift
//  PLFMembership
//
//  Created by HappyDuck on 10/9/23.
//

import UIKit
import SnapKit

final class ImageLabelView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageLabelView {
    func configure(image: UIImage?, text: String) {
        self.imageView.image = image
        self.titleLabel.text = text
    }
}

//MARK: - Set UI
extension ImageLabelView {
    private func setUI() {
        self.addSubviews(self.imageView,
                         self.titleLabel)
    }
    
    private func setLayout() {
        self.imageView.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(self)
            $0.width.equalTo(self.imageView.snp.height)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.imageView.snp.trailing).offset(10)
            $0.top.bottom.trailing.equalTo(self)
        }
    }
}
