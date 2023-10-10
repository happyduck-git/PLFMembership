//
//  ViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/21.
//

import UIKit
import SnapKit
import Combine
import Nuke

final class MainViewController: BaseViewController {
    
    private let vm: MainViewViewModel
    
    private var sideMenuVC: SideMenuViewController?
    
    //MARK: - Combine
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    
    private let loadingVC = LoadingViewController()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "GG님\n안녕하세요!" // temp
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileView: UserProfileView = {
        let view = UserProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Side Menu Controller Manager
    private lazy var slideInTransitioningDelegate = SideMenuPresentationManager()
    
    // MARK: - Init
    init(vm: MainViewViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileView.delegate = self
        self.view.backgroundColor = .white
        
        self.setNavigationItem()
        self.setUI()
        self.setLayout()
        
        self.bind()

        self.addChildViewController(self.loadingVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = nil
    }

}

// MARK: - Bind with VM
extension MainViewController {
    
    private func bind() {
        func bindViewToViewModel() {
            
        }
        
        func bindViewModelToView() {
            self.vm.$ownedNFTs
                .sink { nfts in
                    guard let nft = nfts.first else { return }
                    self.vm.ownedIdCard = nft
                }
                .store(in: &bindings)
            
            self.vm.idCardInfo
                .receive(on: DispatchQueue.main)
                .sink { info in
                    
                    guard let imageUrlString = info.idCard.metadata.image,
                          let imageUrl = URL(string: imageUrlString),
                          let attributes = info.idCard.metadata.attributes
                    else { return }
                    
                    Task {
                        do {
                            // BackgroundView
                            self.addBlurToImageView(self.backgroundImage)
                            let profileImage = try await ImagePipeline.shared.image(for: imageUrl)
                            self.backgroundImage.image = profileImage
                            
                            // UserProfileView
                            var position: String = ""
                            let department: String = "Mobile" // temp
                            let username: String = "GG" // temp
                            var joined: String = ""
                            
                            attributes.forEach {
                                let traitType = AttributeTraitType(rawValue: $0.traitType)
                                switch traitType {
                                case .position:
                                    position = $0.value
                                case .yearOfEntry:
                                    
                                    joined = self.vm.yearsAndMonthsPassed(from: $0.value) ?? "0개월"
                                default:
                                    break
                                }
                            }
                            self.profileView.configure(image: profileImage,
                                                       position: position,
                                                       department: department,
                                                       username: username,
                                                       joined: joined,
                                                       tier: info.tier)
                        }
                        catch {
                            PLFLogger.logger.error("Error loading image -- \(String(describing: error))")
                        }
                    }
                    
                }
                .store(in: &bindings)
     
            self.vm.$isLoaded
                .receive(on: DispatchQueue.main)
                .sink { [weak self] loaded in
                    guard let `self` = self else { return }
                    
                    if loaded {
                        self.loadingVC.removeViewController()
                    }
                }
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }

}

// MARK: - Set UI
extension MainViewController {
    
    private func setUI() {
        self.view.addSubviews(self.backgroundImage,
                              self.welcomeLabel,
                              self.profileView)
    }
    
    private func setLayout() {
        self.backgroundImage.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalTo(self.view)
        }
        
        self.welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(18)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(21)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-21)
        }
        
        self.profileView.snp.makeConstraints {
            $0.top.equalTo(self.welcomeLabel.snp.bottom).offset(68)
            $0.centerX.equalTo(self.view)
            $0.height.equalTo(383)
            $0.width.equalTo(268)
        }
    }
    
    private func setNavigationItem() {
        let menuItem = UIBarButtonItem(image: UIImage(named: ImageAssets.hamburgerMenu)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal),
                                       style: .plain,
                                       target: self,
                                       action: #selector(openSideMenu))
        
        let clockItem = UIBarButtonItem(image: UIImage(named: ImageAssets.clock)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal),
                                        style: .plain,
                                        target: self,
                                        action: #selector(goToTxHistory))
        
        self.navigationItem.setLeftBarButton(menuItem, animated: true)
        self.navigationItem.setRightBarButton(clockItem, animated: true)
        
        self.navigationItem.hidesBackButton = true
    }
}

extension MainViewController {
    @objc
    private func openSideMenu() {
        slideInTransitioningDelegate.direction = .left
        
        let vm = SideMenuViewViewModel()
        let sidemenuVC = SideMenuViewController(vm: vm)
        self.sideMenuVC = sidemenuVC
        sidemenuVC.transitioningDelegate = slideInTransitioningDelegate
        sidemenuVC.modalPresentationStyle = .custom
        sidemenuVC.delegate = self
        self.navigationController?.present(sidemenuVC, animated: true)
    }
    
    @objc
    private func goToTxHistory() {
        
        let vm = TxHistoryViewViewModel()
        let vc = TxHistoryViewController(vm: vm)
        
        self.show(vc, sender: self)
        
    }
}

extension MainViewController: SideMenuViewControllerDelegate {
    
    func menuTableViewController(controller: SideMenuViewController, didSelectRow selectedRow: Int) {
        
        for child in self.children {
            child.removeViewController()
        }
        
        switch selectedRow {
        case 0:
            break
        
        case 1:
            let vm = MyNFTsViewViewModel(mainViewModel: self.vm)
            let vc = MyNFTsViewController(vm: vm)
            self.addChildViewController(vc)
        
        default:
            break
        }
        
        self.sideMenuVC?.dismiss(animated: true)
    }
    
}

extension MainViewController: UserProfileViewDelegate {
    func g3LogoDidTap() {
        for child in self.children {
            child.removeViewController()
        }

        self.addChildViewController(G3ViewController())
    }
}

extension MainViewController {
    
    /// Make blur effect of UIImageView.
    /// - Parameter imageView: An UIImageView to apply blur effect.
    func addBlurToImageView(_ imageView: UIImageView) {
        // Ensure the imageView does not have a clear background color
        imageView.backgroundColor = .clear

        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        // Match the frame and bounds of the blur view to the image view
        blurEffectView.frame = imageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for auto resizing

        imageView.addSubview(blurEffectView)
    }
   
}
