//
//  DiscoverUserProfileView.swift
//  PLFMembership
//
//  Created by Platfarm on 10/12/23.
//

import UIKit
import SnapKit

final class DiscoverUserProfileView: UIView {

    // MARK: - UI Elements
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textColor = PLFColor.gray02
        label.font = .systemFont(ofSize: 12.0, weight: .semibold)
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImage.snp.makeConstraints {
            $0.width.equalTo(self.profileImage.snp.height)
        }
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
    }
    
}

extension DiscoverUserProfileView {
    func configure(image: UIImage?,
                   username: String,
                   time: String) {
        self.profileImage.image = image
        self.usernameLabel.text = String(username.prefix(8))
        
        let timePassed = self.timePassedSince(dateString: time)
        self.timeLabel.text = timePassed
    }
    
    private func timePassedSince(dateString: String) -> String {
        let hours = self.hoursSince(dateString: dateString) ?? 0
        
        if hours >= 24 {
            return "\(hours / 24) days ago"
        }
        return "\(hours) days ago"
    }
    
    private func hoursSince(dateString: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")  // To ensure consistent parsing

        guard let givenDate = dateFormatter.date(from: dateString) else {
            return nil  // Invalid date string
        }

        let currentDate = Date()
        let elapsedTimeInterval = currentDate.timeIntervalSince(givenDate)
        let elapsedHours = Int(elapsedTimeInterval / 3600)  // Convert seconds to hours

        return elapsedHours
    }
}

// MARK: - Set UI & Layout
extension DiscoverUserProfileView {
    private func setUI() {
        self.addSubviews(self.profileImage,
                         self.nameStack)
        self.nameStack.addArrangedSubviews(self.usernameLabel,
                                           self.timeLabel)
    }
    
    private func setLayout() {
        self.profileImage.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(self)
        }
        self.nameStack.snp.makeConstraints {
            $0.leading.equalTo(self.profileImage.snp.trailing).offset(10)
            $0.top.trailing.bottom.equalTo(self)
        }
        
    }
}
