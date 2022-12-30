//
//  TweetHeader.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/27.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    // MARK: - Properties
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
    private let fullnameLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "소년탐정"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "@김전일"
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 0
        label.text = "이 편지는 영국으로부터 시작되어, 하루에 3명에게 같은 내용의 편지를 전달해야합니다. 그렇지 않을 경우, 감당할 수 없는 행복한 일들이 가득할껍니다."
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "6:33PM 12/30/2022"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleretweetsTapped))
        label.text = "0 Retweets"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handlelikesTapped))
        label.text = "0 Likes"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private lazy var statsView: UIView = {
       let view = UIView()
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top:view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 1.0 )
        
        
        let retweetsAndLikesLabelStack = UIStackView(arrangedSubviews: [retweetsLabel,likesLabel])
        retweetsAndLikesLabelStack.axis = .horizontal
        retweetsAndLikesLabelStack.spacing = 12
        view.addSubview(retweetsAndLikesLabelStack)
        retweetsAndLikesLabelStack.centerY(inView: view)
        retweetsAndLikesLabelStack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0 )
        
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame) 
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top:topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: stack.leftAnchor, paddingTop: 20)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, height: 40)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selector
    @objc func handleProfileImageTapped() {
        
    }
    @objc func showActionSheet() {
        print("DEBUG: Push Option")
    }
    @objc func handleretweetsTapped() {
        print("DEBUG: Retweets Label Tapped")
    }
    @objc func handlelikesTapped() {
        print("DEBUG: Likes Label Tapped")
    }
    // MARK: - Helpers
    func configure() {
        
    }
}
