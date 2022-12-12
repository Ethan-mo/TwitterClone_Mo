//
//  ProfileHeader.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/07.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    private let filterBar = ProfileFilterView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top:view.topAnchor, left: view.leftAnchor,
                          paddingTop: 43,paddingLeft: 16,width: 30, height: 30)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
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
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "이 편지는 영국으로부터 시작되어, 하루에 3명에게 같은 내용의 편지를 전달해야합니다. 그렇지 않을 경우, 감당할 수 없는 행복한 일들이 가득할껍니다."
        return label
    }()
    
    private let divLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // containerView에 대한 레이아웃 설정
        addSubview(containerView)
        containerView.anchor(top:topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        // profileImageView에 대한 레이아웃 설정
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8,
                                width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        // editProfileFollowButton에 대한 레이아웃 설정
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor,right: rightAnchor, paddingTop: 12, paddingRight: 12,
                                       width: 100,height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        
        addSubview(userDetailStack)
        userDetailStack.anchor(top:profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                               paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        addSubview(filterBar)
        //filterBar.delegate = self
        filterBar.anchor(left: leftAnchor,bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selector
    @objc func handleDismissal() {
        
    }
    @objc func handleEditProfileFollow() {
        
    }
}
