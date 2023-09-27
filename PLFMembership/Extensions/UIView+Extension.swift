//
//  UIView+Extension.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/26.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
