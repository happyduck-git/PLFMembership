//
//  ViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/21.
//

import UIKit

final class MainViewController: BaseViewController {
    
    private var sideMenuVC: SideMenuViewController?
    
    // MARK: - Side Menu Controller Manager
    private lazy var slideInTransitioningDelegate = SideMenuPresentationManager()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.setNavigationItem()
        
        Task {
            let result = try await AlchemyServiceManager.shared.requestCouponTransfers()
            print("Result: \(result)")
        }
    }

}

extension MainViewController {
    private func setNavigationItem() {
        let menuItem = UIBarButtonItem(image: UIImage(named: ImageAssets.hamburgerMenu)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal),
                                       style: .plain,
                                       target: self,
                                       action: #selector(openSideMenu))
        
        self.navigationItem.setLeftBarButton(menuItem, animated: true)
        self.navigationItem.hidesBackButton = true
    }
}

extension MainViewController {
    @objc func openSideMenu() {
        slideInTransitioningDelegate.direction = .left
        
        let vm = SideMenuViewViewModel()
        let sidemenuVC = SideMenuViewController(vm: vm)
        self.sideMenuVC = sidemenuVC
        sidemenuVC.transitioningDelegate = slideInTransitioningDelegate
        sidemenuVC.modalPresentationStyle = .custom
        sidemenuVC.delegate = self
        self.navigationController?.present(sidemenuVC, animated: true)
    }
}

extension MainViewController: SideMenuViewControllerDelegate {
    
    func menuTableViewController(controller: SideMenuViewController, didSelectRow selectedRow: Int) {
        // TODO: 
    }
    
}
