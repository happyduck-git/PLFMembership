//
//  DiscoverViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 10/11/23.
//

import UIKit
import Combine

final class DiscoverViewController: BaseViewController {

    private var bindings = Set<AnyCancellable>()
    
    // MARK: - View Model
    private let vm: DiscoverViewViewModel
    
    // MARK: - UI Elements
    private let loadingVC = LoadingViewController()
    
    private let feedTableView: UITableView = {
        let table = UITableView()
        table.register(DiscoverTableViewCell.self, forCellReuseIdentifier: DiscoverTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Init
    init(vm: DiscoverViewViewModel) {
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
        self.title = "Discover"
        
        self.setUI()
        self.setLayout()
        self.setDelegate()
        
        self.bind()
        self.addChildViewController(self.loadingVC)
    }

}

extension DiscoverViewController {
    private func bind() {
        func bindViewToViewModel() {
            
        }
        func bindViewModelToView() {
          
            self.vm.transferHistoryList
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    guard let `self` = self else { return }
                    print("Result: \(result.count)")
                    self.vm.transferHistoryData = result
                    self.feedTableView.reloadData()
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

// MARK: - Set UI & Layout
extension DiscoverViewController {
    private func setDelegate() {
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
    }
    
    private func setUI() {
        self.view.addSubview(self.feedTableView)
    }
    
    private func setLayout() {
        self.feedTableView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.vm.sortedTransferHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverTableViewCell.identifier, for: indexPath) as? DiscoverTableViewCell else { fatalError() }
        
        let data = self.vm.sortedTransferHistoryData[indexPath.row]
        
        switch data.type {
        case .coupon:
            print("FROM: \(data.transfer.from.lowercased())")
            if data.transfer.from.lowercased() == "0xC7904B3F9842F42E04e110aF90001748DF264880".lowercased() {
                cell.configure(type: .newCoupon, vm: data, at: indexPath)
            } else {
                cell.configure(type: .used, vm: data, at: indexPath)
            }
            
        case .idCard:
            cell.configure(type: .newMember, vm: data, at: indexPath)
            
        case .poap:
            cell.configure(type: .poap, vm: data, at: indexPath)
        }
        
        cell.bind()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.vm.sortedTransferHistoryData[indexPath.row]
        
        print("Selected Cell at \(indexPath.row): \(data)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 2
    }
}
