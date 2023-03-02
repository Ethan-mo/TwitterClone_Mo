//
//  MessageCell.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/02/28.
//

import UIKit

class MessageCell: UICollectionViewCell {
    // MARK: - Properties
    var message: Message? {
        didSet{
            configure()
        }
    }
    private var bubbleLeftContainer: NSLayoutConstraint!
    private var bubbleRightContainer: NSLayoutConstraint!
    
    
    lazy var profileImageView: UIImageView = {
        let profileIV = UIImageView()
        profileIV.backgroundColor = .lightGray
        profileIV.contentMode = .scaleAspectFill
        profileIV.clipsToBounds = true
        return profileIV
    }()
    private lazy var textView: UITextView = {
       let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .white
        tv.text = "테스트 메세지"
        return tv
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(left:leftAnchor, bottom: bottomAnchor, paddingLeft: 8, paddingBottom: -4)
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor(top: topAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleLeftContainer = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleLeftContainer.isActive = false
        bubbleRightContainer = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightContainer.isActive = false
        
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top:bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func configure() {
        guard let message = message else { return }
        let viewModel = MessageViewModel(message: message)
        bubbleContainer.backgroundColor = viewModel.isTextBackgroundColor
        textView.textColor = viewModel.isTextColor
        
        bubbleLeftContainer.isActive = viewModel.bubbleLeftAnchor
        bubbleRightContainer.isActive = viewModel.bubbleRightAnchor
        
        profileImageView.isHidden = viewModel.isProfileImage
        
        textView.text = message.message
    }
}
