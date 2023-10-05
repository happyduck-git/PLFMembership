//
//  TitleBadgeView.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import UIKit
import SnapKit

final class TitleBadgeView: UIView {
    
    // MARK: - UI Elements
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
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

// MARK: - Set UI
extension TitleBadgeView {
    private func setUI() {
        self.addSubviews(self.title)
    }
    
    private func setLayout() {
        self.title.snp.makeConstraints {
            $0.top.leading.equalTo(self).offset(10)
            $0.bottom.trailing.equalTo(self).offset(-10)
        }
    }
}
