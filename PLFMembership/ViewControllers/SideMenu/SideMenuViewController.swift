//
//  SideMenuViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/26.
//

import UIKit
import Combine

protocol SideMenuViewControllerDelegate: AnyObject {
    func menuTableViewController(controller: SideMenuViewController, didSelectRow selectedRow: Int)
}

final class SideMenuViewController: BaseViewController {

    // MARK: - Dependency
    private let vm: SideMenuViewViewModel

    // MARK: - Combine
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Delegate
    weak var delegate: SideMenuViewControllerDelegate?
    
    // MARK: - UI Elements
    private let menuTable: UITableView = {
        let table = UITableView()
        table.isScrollEnabled = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
   
    // MARK: - Init
    init(vm: SideMenuViewViewModel) {
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
        
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
    }

}

// MARK: - Bind
extension SideMenuViewController {
    
    private func bind() {
        func bindViewToViewModel() {
           
        }
        func bindViewModelToView() {
            
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
}

// MARK: - TableView Delegate & DataSource
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    private func setUI() {
        view.addSubviews(self.menuTable)
    }
    
    private func setLayout() {
        self.menuTable.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalTo(self.view)
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.numberOfMenu()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        
        let menu = self.vm.getMenu(of: indexPath.item)
        
        config.image = UIImage(named: menu.image)
        config.text = menu.title
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.menuTableViewController(controller: self, didSelectRow: indexPath.row)
    }
}


