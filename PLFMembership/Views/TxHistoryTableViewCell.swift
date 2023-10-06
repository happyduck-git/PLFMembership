//
//  TxHistoryTableViewCell.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/10/05.
//

import UIKit
import Combine

enum TransferType: String {
    case mint
    case transfer
    
    var bgColor: UIColor {
        switch self {
        case .mint:
            return PLFColor.backgroundMint
        case .transfer:
            return PLFColor.backgroundBlue
        }
    }
    
    var iconName: String {
        switch self {
        case .mint:
            return ImageAssets.sparkles
        case .transfer:
            return ImageAssets.arrowBiDirection
        }
    }
}

final class TxHistoryTableViewCell: UITableViewCell {
    
    enum LeftColumnItem: String, CaseIterable {
        case title = "Title"
        case transferType
        case from = "From"
        case to = "To"
    }
    
    enum RightColumnItem: String, CaseIterable {
        case tokenId = "Token ID"
        case date = "Date"
    }
    
    private let leftColumnItems: [LeftColumnItem] = LeftColumnItem.allCases
    private let rightColumnItems: [RightColumnItem] = RightColumnItem.allCases
    private var infoViews: [TraitDetailView] = []
    
    // MARK: - UI Elements
    private let wholeStack: UIStackView = {
    let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let leftStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let rightStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.makeStackViews()
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
    }
}

// MARK: - Set UI
extension TxHistoryTableViewCell {
    
    private func setUI() {
        self.contentView.addSubview(self.wholeStack)
        
        self.wholeStack.addArrangedSubviews(self.leftStack,
                                            self.rightStack)
    }
    
    private func setLayout() {
        self.wholeStack.snp.makeConstraints {
            $0.top.equalTo(self.contentView).offset(15)
            $0.leading.equalTo(self.contentView).offset(10)
            $0.bottom.equalTo(self.contentView).offset(-15)
            $0.trailing.equalTo(self.contentView).offset(-10)
        }
    }
    
}

// MARK: - Configure
extension TxHistoryTableViewCell {
    func configure(with transfer: Transfer) {
        
        var type: TransferType = .mint
        
        if transfer.from == "0x0000000000000000000000000000000000000000" {
            type = .mint
        } else {
            type = .transfer
        }
        
        self.contentView.backgroundColor = type.bgColor
        
        self.infoViews.forEach { view in
            
            var value: String = ""
            
            switch view.tag {
            case 0:
                value = transfer.category
            case 1:
                value = "n/a"
            case 2:
                value = transfer.from
            case 3:
                value = transfer.to
            case 4:
                value = transfer.erc721TokenId ?? "0x000"
            case 5:
                value = transfer.metadata.blockTimestamp
            default:
                break
            }
            view.configureValue(value: value)
        }

    }
}

extension TxHistoryTableViewCell {

    private func makeStackViews() {
        var tag: Int = 0
        
        self.leftColumnItems.forEach { item in
            switch item {
//            case .transferType:
                //TODO: Image - Label view 이용하기
                
            default:
                let view = TraitDetailView()
                view.tag = tag
                view.configure(title: item.rawValue, value: "vv")
                
                self.infoViews.append(view)
                self.leftStack.addArrangedSubview(view)
            }
            
            tag += 1
        }
        
        self.rightColumnItems.forEach { item in
            let view = TraitDetailView()
            view.tag = tag
            view.configure(title: item.rawValue, value: "vv")
            
            self.infoViews.append(view)
            self.rightStack.addArrangedSubview(view)
            
            tag += 1
        }
    }
}
