//
//  PassThroughView.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/04.
//

import UIKit

class PassThroughView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }

}
