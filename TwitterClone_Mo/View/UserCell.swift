//
//  UserCell.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/20.
//

import UIKit

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    var user:User?{
        didSet {configure()}
    }
    
    private var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private var userNameLabel: UILabel = {
       let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.numberOfLines = 1
        return lb
    }()
    private var fullNameLabel: UILabel = {
       let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.numberOfLines = 1
        return lb
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 8)
        let stack = UIStackView(arrangedSubviews: [userNameLabel,fullNameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.anchor(top:profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Seletor
    
    // MARK: - Helper
    func configure() {
        guard let user = user else { return }
        profileImageView.sd_setImage(with: user.profileImageUrl)
        userNameLabel.text = user.username
        fullNameLabel.text = user.fullname
    }
    
}
