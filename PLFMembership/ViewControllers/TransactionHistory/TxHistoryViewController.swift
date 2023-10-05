//
//  TxHistoryViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import UIKit

final class TxHistoryViewController: BaseViewController {

    private let vm: TxHistoryViewViewModel

    // MARK: - Init
    init(vm: TxHistoryViewViewModel) {
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
    }

}
