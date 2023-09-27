//
//  LoadingViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/25.
//

import UIKit
import SnapKit

final class LoadingViewController: UIViewController {

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .white
        spinner.style = .large
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGray
        self.view.alpha = 0.2
        
        self.setUI()
        self.setLayout()
        
        self.spinner.startAnimating()
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.spinner.stopAnimating()
    }

}

extension LoadingViewController {
    private func setUI() {
        self.view.addSubview(self.spinner)
    }
    
    private func setLayout() {
        self.spinner.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }
}
