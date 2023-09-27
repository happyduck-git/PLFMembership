//
//  UIButton+Extensions.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/25.
//

import UIKit.UIButton
import Combine

// MARK: - Combine Publisher
extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
