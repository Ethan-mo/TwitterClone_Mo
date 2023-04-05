//
//  ConversationCell.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/02/06.
//

import UIKit
import SDWebImage

class ConversationCell: UITableViewCell {
    // MARK: - Properties
    var conversation: Conversation? {
        didSet {
            configureUI()
        }
    }
    private lazy var profileImageView: UIImageView = {
        let profileIV = UIImageView()
        profileIV.backgroundColor = .systemPurple
        profileIV.contentMode = .scaleAspectFill
        profileIV.clipsToBounds = true
        return profileIV
    }()
    private var nicknameLabel: UILabel = {
       let nicknameLB = UILabel()
        nicknameLB.font = UIFont.boldSystemFont(ofSize: 16)
        nicknameLB.text = "닉네임"
        return nicknameLB
    }()
    private var messageLabel: UILabel = {
       let message = UILabel()
        message.font = UIFont.systemFont(ofSize: 18)
        message.text = "전달해온 메세지 내용은"
        return message
    }()
    private var timeStampLabel: UILabel = {
       let timeStamp = UILabel()
        timeStamp.font = UIFont.systemFont(ofSize: 12)
        timeStamp.textColor = .systemGray
        timeStamp.text = "시간"
        return timeStamp
    }()
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(width: 50, height: 50)
        profileImageView.layer.cornerRadius = 25
        
        let stack = UIStackView(arrangedSubviews: [nicknameLabel, messageLabel])
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 4
        addSubview(stack)
        stack.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8)
        
        addSubview(timeStampLabel)
        timeStampLabel.anchor(top: profileImageView.topAnchor, right: rightAnchor, paddingRight: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helper
    func configureUI() {
        guard let conversation = conversation else { return }
        let viewModel = ConversationViewModel.init(conversation: conversation)
        
        profileImageView.sd_setImage(with: conversation.user.profileImageUrl)
        nicknameLabel.text = conversation.user.username
        messageLabel.text = conversation.message.text
        timeStampLabel.text = viewModel.timestamp
    }
    
}
