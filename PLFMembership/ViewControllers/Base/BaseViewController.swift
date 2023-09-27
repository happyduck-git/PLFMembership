//
//  BaseViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/25.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


}

// MARK: - Alert Controller
extension BaseViewController {
    func showAlert(alertTitle: String?,
                   alertMessage: String?,
                   alertStyle: UIAlertController.Style,
                   actionTitle: String?,
                   actionStyle: UIAlertAction.Style) {
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: alertStyle
        )
        
        let action = UIAlertAction(
            title: actionTitle,
            style: actionStyle
        )
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
}
