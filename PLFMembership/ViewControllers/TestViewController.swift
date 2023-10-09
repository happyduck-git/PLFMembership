//
//  TestViewController.swift
//  PLFMembership
//
//  Created by HappyDuck on 10/8/23.
//

import UIKit

final class TestViewController: UIViewController {
    
    private let loadingVC = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addChildViewController(self.loadingVC)
    }
    
}

#Preview {
    TestViewController()
}
