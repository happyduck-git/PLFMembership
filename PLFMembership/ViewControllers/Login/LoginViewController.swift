//
//  LoginViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/25.
//

import UIKit
import Combine
import SnapKit
import metamask_ios_sdk

final class LoginViewController: BaseViewController {
    
    private let ethereum = MetaMaskSDK.shared.ethereum
    private let dapp = Dapp(name: "PLFMembership", url: "https://plf-membership.com")
    
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - View Model
    private let vm: LoginViewViewModel
    
    // MARK: - UI Elements
    private let loadingVC = LoadingViewController()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "After (Platfarm) Mint"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var demoBtn1: UIButton = {
        let btn = UIButton()
        btn.setTitle("DEMO ACOOUNT1", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(hex: 0x7FE8FF)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = UIConstant.buttonRadius
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var demoBtn2: UIButton = {
        let btn = UIButton()
        btn.setTitle("DEMO ACOOUNT2", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = PLFColor.backgroundBlue
        btn.clipsToBounds = true
        btn.layer.cornerRadius = UIConstant.buttonRadius
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var metaMaskLoginBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: ImageAssets.metamaskLogo), for: .normal)
        btn.setTitle(LoginConstant.metamaskLogin, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(hex: 0x7FE8FF)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = UIConstant.buttonRadius
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Init
    init(vm: LoginViewViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.setUI()
        self.setLayout()
        self.bind()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
}

// MARK: - Bind
extension LoginViewController {
    
    private func bind() {
        func bindViewToViewModel() {
            
            self.demoBtn1.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let `self` = self else { return }
                    
                    MainConstants.userAddress = "0x04dBF23edb725fe9C859908D76E9Ccf38BC80a13"
                    let vm = MainViewViewModel()
                    let vc = MainViewController(vm: vm)
                    
                    self.show(vc, sender: self)
                }
                .store(in: &bindings)
            
            self.demoBtn2.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let `self` = self else { return }
                    
                    MainConstants.userAddress = "0x1f5F3bfDd93f6b0a626DaB250819A9f9273EAfed"
                    let vm = MainViewViewModel()
                    let vc = MainViewController(vm: vm)
                    
                    self.show(vc, sender: self)
                }
                .store(in: &bindings)
            
            self.metaMaskLoginBtn.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let `self` = self else { return }
                
                    self.addChildViewController(self.loadingVC)
                    
                    ethereum.connect(self.dapp)?
                        .sink(receiveCompletion: { [weak self] completion in
                            guard let `self` = self else { return }
                            
                            switch completion {
                            case let .failure(error):
                                self.loadingVC.removeViewController()
                                self.showWalletConnectiontFailedAlert()
                                PLFLogger.logger.error("Connection error: \(String(describing: error))")
                                
                            default: break
                            }
                        }, receiveValue: { result in
                            self.loadingVC.removeViewController()
                            PLFLogger.logger.info("Connection result: \(String(describing: result))")
                            self.saveWalletAddress(address: result as? String)
                            self.vm.walletConnected = true
                        }).store(in: &bindings)
                    
                }
                .store(in: &bindings)
        }
        
        func bindViewModelToView() {
            self.vm.$walletConnected
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    guard let `self` = self else { return }
                    
                    if $0 {
                        let vm = MainViewViewModel()
                        let vc = MainViewController(vm: vm)
                        
                        self.show(vc, sender: self)
                        
                    } else {
                        return
                    }
                }
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }

}

// MARK: - Set UI & Layout
extension LoginViewController {
    private func setUI() {
        self.view.addSubviews(self.titleLabel,
                              self.demoBtn1,
                              self.demoBtn2,
                              self.metaMaskLoginBtn)
    }
    
    private func setLayout() {
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(100)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-5)
        }
        
        self.demoBtn1.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(self.view).offset(-200)
            $0.height.equalTo(60)
        }
        
        self.demoBtn2.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(self.demoBtn1.snp.bottom).offset(20)
            $0.width.equalTo(self.view).offset(-200)
            $0.height.equalTo(60)
        }
        
        self.metaMaskLoginBtn.snp.makeConstraints {
            $0.top.equalTo(self.demoBtn2.snp.bottom).offset(20)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(self.view).offset(-100)
            $0.height.equalTo(60)
            $0.bottom.equalTo(self.view).offset(-100)
        }
    }

}

// MARK: - Private
extension LoginViewController {
    
    private func saveWalletAddress(address: String?) {
        UserDefaults.standard.set(address, forKey: UserDefaultsConst.walletAddress)
    }
    
    private func showWalletConnectiontFailedAlert() {
        self.showAlert(alertTitle: "지갑 연결 실패",
                       alertMessage: "다시 한번 시도해주세요.",
                       alertStyle: .alert,
                       actionTitle1: "확인",
                       actionStyle1: .cancel)
    }
}
