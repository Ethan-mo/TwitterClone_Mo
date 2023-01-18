//
//  ProfileHeader.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/07.
//

import UIKit
import Firebase

protocol ProfileHeaderDelegate : class {
    func handleDismissal()
    func handleEditProfileFollow(_ header: ProfileHeader)
    func didSelect(filter: ProfileFilterOptions)
}

class ProfileHeader: UICollectionReusableView {

    // MARK: - Properties
    weak var delegate: ProfileHeaderDelegate?
    
    var user: User? {
        didSet{
            configure()
        }
    }
    
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
    
    lazy var editProfileFollowButton: UIButton = {
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
    private let divlineView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    
    private let followersLabel: UILabel = {
        let label = UILabel()        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
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
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel,followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.anchor(top:userDetailStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
            
        
        addSubview(filterBar)
        //filterBar.delegate = self
        filterBar.anchor(left: leftAnchor,bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        addSubview(divlineView)
        divlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
        
        
        let count = CGFloat(ProfileFilterOptions.allCases.count)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selector
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }
    @objc func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }
    @objc func handleFollowersTapped() {
        
    }
    @objc func handleFollowingTapped() {
        
    }
    // MARK: - API

    // MARK: - Helpers
    func configure() {
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        followingLabel.attributedText = viewModel.following
        followersLabel.attributedText = viewModel.followers
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        
        //User에서 기본정보 불러오기.
        profileImageView.sd_setImage(with: user.profileImageUrl)
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.userNameText
        
    }
}
extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, diSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else { return }
        
        print("DEBUG: FilterView에서 실행한 delegate로 컨트롤러로 작업을 위임합니다. 즉 2중으로 위임을 시키겠다는 말씀~ \(filter.descroption)")
        
        delegate?.didSelect(filter: filter)
    }
}
