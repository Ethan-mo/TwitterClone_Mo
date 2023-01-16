//
//  NotificationCell.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/16.
//

import UIKit

protocol NotificationDelegate: class {
    func handleProfileImageTapped(_ cell: UITableViewCell)
}

class NotificationCell: UITableViewCell {
    // MARK: - Properties
    
    var delegate:NotificationDelegate?
    
    var notification:Notification {
        didSet{
            configureUi()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    private lazy var notificationMessage: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private lazy var timeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selector
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    // MARK: - Helper
    func configureUi() {
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationMessage, timeLabel])
        stack.spacing = 8
        stack.alignment = .center
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        stack.anchor(right:rightAnchor)
    }
}
