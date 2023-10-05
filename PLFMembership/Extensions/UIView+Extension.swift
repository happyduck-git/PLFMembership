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

extension UIView {
    func setGradientBorder() {
        let gradient = UIImage.gradientImage(bounds: self.bounds,
                                             colors: [PLFColor.gradient09middle2,
                                                      PLFColor.gradient09middle1,
                                                      .white,
                                                      PLFColor.gradient09deep],
                                             startPoint: CGPoint(x: 1.0, y: 0.0),
                                             endPoint: CGPoint(x: 0.0, y: 1.0))
        let graidentColor = UIColor(patternImage: gradient)
        self.layer.borderColor = graidentColor.cgColor
    }
}
