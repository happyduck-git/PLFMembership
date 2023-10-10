//
//  G3ViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 10/10/23.
//

import UIKit
import WebKit

final class G3ViewController: BaseViewController {

    private let g3Url = "https://gall3ry.io/rkrudtls"
    
    private let topView: UIView = {
       let view = UIView()
        
        return view
    }()
    
    private let webView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.setUI()
        self.setLayout()
        
        self.connectToG3Web()
    }
    
}

extension G3ViewController {
 
    private func setUI() {
        self.view.addSubview(self.webView)
    }
    
    private func setLayout() {
        self.webView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension G3ViewController {
    private func connectToG3Web() {
        guard let url = URL(string: self.g3Url) else { return }
        webView.load(URLRequest(url: url))
    }
}
