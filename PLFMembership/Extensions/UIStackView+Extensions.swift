//
//  UIStackView+Extensions.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/04.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}
