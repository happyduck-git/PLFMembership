//
//  CheckerLottieLoadingViewController.swift
//  PLFMembership
//
//  Created by HappyDuck on 10/22/23.
//

import UIKit
import SnapKit
import Lottie

final class CheckerLottieLoadingViewController: UIViewController {

    private let spinnerBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.layer.cornerRadius = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkView: LottieAnimationView = {
        let lottie = LottieAnimationView(name: "check-mark")
        lottie.translatesAutoresizingMaskIntoConstraints = false
        return lottie
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGray
        self.view.alpha = 0.2
        
        self.setUI()
        self.setLayout()
        
        self.checkView.play()
    }

}

extension CheckerLottieLoadingViewController {
    private func setUI() {
        self.view.addSubview(self.spinnerBackground)
        self.spinnerBackground.addSubview(self.checkView)
    }
    
    private func setLayout() {
        self.spinnerBackground.snp.makeConstraints {
            $0.center.equalTo(self.view)
            $0.width.height.equalTo(80)
        }
        
        self.checkView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalTo(self.spinnerBackground)
        }
    }
}
