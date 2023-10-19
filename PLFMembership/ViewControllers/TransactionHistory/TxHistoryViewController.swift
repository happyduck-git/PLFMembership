//
//  TxHistoryViewController.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import UIKit
import Combine

final class TxHistoryViewController: BaseViewController {

    // MARK: - View Model
    private let vm: TxHistoryViewViewModel
    
    // MARK: - Combine
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    
    private let loadingVC = LoadingViewController()
    
    private let menuButtonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let nftMenuButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("NFT", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return btn
    }()
    
    private let couponMenuButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(String(localized: "쿠폰"), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return btn
    }()
    
    private let menuUnderlineBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = PLFColor.mint04
        return bar
    }()
    
    private let nftHistoryTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        table.register(TxHistoryTableViewCell.self, forCellReuseIdentifier: TxHistoryTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 150.0 // or some average height
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let couponHistoryTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        table.register(TxHistoryTableViewCell.self, forCellReuseIdentifier: TxHistoryTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.isHidden = true
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 150.0 // or some average height

        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

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
        
        self.setUI()
        self.setLayout()
        self.setDelegate()
        
        self.bind()
        
        self.addChildViewController(self.loadingVC)
    }

}

// MARK: - Bind with View Model
extension TxHistoryViewController {
    private func bind() {
        func bindViewToViewModel() {
            self.nftMenuButton.tapPublisher
                .sink(receiveValue: { [weak self] in
                    guard let `self` = self else { return }
                    
                    if !self.vm.nftButtonTapped {
                        self.vm.nftButtonTapped = true
                        self.vm.couponButtonTapped = false
                    }
                })
                .store(in: &bindings)
            
            self.couponMenuButton.tapPublisher
                .sink(receiveValue: { [weak self] in
                    guard let `self` = self else { return }
                    
                    if !self.vm.couponButtonTapped {
                        self.vm.couponButtonTapped = true
                        self.vm.nftButtonTapped = false
                    }
                })
                .store(in: &bindings)
        
        }
        func bindViewModelToView() {
            self.vm.$nftTransferHistoryList
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let `self` = self else { return }
                    
                    self.nftHistoryTable.reloadData()
                }
                .store(in: &bindings)
            
            self.vm.$couponTransferHistoryList
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let `self` = self else { return }
                    
                    self.couponHistoryTable.reloadData()
                }
                .store(in: &bindings)
            
            self.vm.$nftButtonTapped
                .sink { [weak self] tapped in
                    guard let `self` = self else { return }
                    
                    if tapped {
                        self.nftMenuButton.setTitleColor(PLFColor.mint04, for: .normal)
                        self.nftHistoryTable.isHidden = false
                    } else {
                        self.nftMenuButton.setTitleColor(.gray, for: .normal)
                        self.nftHistoryTable.isHidden = true
                    }
                }
                .store(in: &bindings)
            
            self.vm.$couponButtonTapped
                .sink { [weak self] tapped in
                    guard let `self` = self else { return }
                    
                    if tapped {
                        self.couponMenuButton.setTitleColor(PLFColor.mint04, for: .normal)
                        self.couponHistoryTable.isHidden = false
                    } else {
                        self.couponMenuButton.setTitleColor(.gray, for: .normal)
                        self.couponHistoryTable.isHidden = true
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
extension TxHistoryViewController {
    
    private func setDelegate() {
        self.nftHistoryTable.delegate = self
        self.nftHistoryTable.dataSource = self
        
        self.couponHistoryTable.delegate = self
        self.couponHistoryTable.dataSource = self
    }
    
    private func setUI() {
        self.view.addSubviews(self.menuButtonStack,
                              self.menuUnderlineBar,
                              self.nftHistoryTable,
                              self.couponHistoryTable)
        
        self.menuButtonStack.addArrangedSubviews(self.nftMenuButton,
                                                 self.couponMenuButton)
    }
    
    private func setLayout() {
        self.menuButtonStack.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        
        self.menuUnderlineBar.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.bottom.equalTo(self.menuButtonStack.snp.bottom)
            $0.width.equalTo(self.view) // TODO: Dynamic 하게 변경 and half the size
        }
        
        self.nftHistoryTable.snp.makeConstraints {
            $0.top.equalTo(self.menuButtonStack.snp.bottom)
            $0.leading.bottom.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.couponHistoryTable.snp.makeConstraints {
            $0.top.equalTo(self.menuButtonStack.snp.bottom)
            $0.leading.bottom.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}

extension TxHistoryViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.nftHistoryTable {
            return self.vm.nftTransferHistoryList.count
        } else {
            
            return self.vm.couponTransferHistoryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TxHistoryTableViewCell.identifier, for: indexPath) as? TxHistoryTableViewCell else {
            return UITableViewCell()
        }
        
        
        if tableView == self.nftHistoryTable {
            cell.configure(with: self.vm.nftTransferHistoryList[indexPath.row])
            return cell
        } else if tableView == self.couponHistoryTable {
            cell.configure(with: self.vm.couponTransferHistoryList[indexPath.row])
            
            return cell
        } else {
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
