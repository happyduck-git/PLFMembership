//
//  TraitDetailView.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import UIKit

final class TraitDetailView: UIView {
    
    // MARK: - UI Elements
    private let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18)
        label.textColor = PLFColor.gray02
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let value: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.lineBreakMode = .byTruncatingMiddle
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
extension TraitDetailView {
    func configure(title: String, value: String) {
        self.title.text = title
        self.value.text = value
    }
    
    func configureValue(value: String) {
        self.value.text = value
    }
}

// MARK: - Set UI
extension TraitDetailView {
    
    private func setUI() {
        self.addSubviews(self.title,
                         self.value)
    }
    
    private func setLayout() {
        self.title.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(self)
        }
        
        self.value.snp.makeConstraints {
            $0.leading.equalTo(self.title.snp.trailing).offset(10)
            $0.top.bottom.trailing.equalTo(self)
        }
    }
    
}
