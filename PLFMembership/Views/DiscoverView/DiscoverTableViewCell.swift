//
//  DiscoverTableViewCell.swift
//  PLFMembership
//
//  Created by Platfarm on 10/11/23.
//

import UIKit
import SnapKit

//PCN
//PES

final class DiscoverTableViewCell: UITableViewCell {
    
    private let imageContainerView: UIView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let discoverButtonView: DiscoverButtonView = {
        let view = DiscoverButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = PLFColor.gray02
        label.font = .systemFont(ofSize: 12.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tokenIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = PLFColor.darkGray
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = PLFColor.gray02
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let filledHeartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .heartRed)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let numberOfLikesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyHeartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .heartEmpty)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let shareImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .share)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension DiscoverTableViewCell {
    private func setUI() {
        self.contentView.addSubviews(self.imageContainerView, self.)
    }
}
