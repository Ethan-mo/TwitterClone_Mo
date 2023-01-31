//
//  TweetCell.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/05.
//

import UIKit
import SDWebImage
import ActiveLabel

protocol TweetCellDelegate: class {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
    func handleMentionTapped(_ cell: TweetCell, username: String)
    func handleHashTagTapped(_ cell: TweetCell, username: String)
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    var cellCount: Int = 0
    var tweet:Tweet?{
        didSet{ configure() }
    }
    
    weak var delegate: TweetCellDelegate?
    
    // #selector가 있어서 lazy로 해주어야한다.
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
    
    private let replyLabel: ActiveLabel = {
       let label = ActiveLabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.mentionColor = .twitterBlue
        return label
    }()
    
    private let captionLabel: ActiveLabel = {
       let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        label.text = "Some test caption"
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    private let infoLabel = UILabel()
    
    // MARK: - Lifecycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        

        
        let captionStack = UIStackView(arrangedSubviews: [infoLabel,captionLabel])
        captionStack.axis = .vertical
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 4
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionStack])
        imageCaptionStack.distribution = .fillProportionally
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top:topAnchor,left:leftAnchor,right: rightAnchor,
                     paddingTop: 4, paddingLeft: 12, paddingRight: 12)
        
        let buttonStack = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 72
        addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.anchor(top: stack.bottomAnchor ,bottom: bottomAnchor,
                           paddingTop: 8, paddingBottom: 8)
        
        
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.text = "Eddie Brock @venom"
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
        
        configureMentionHandler()
        configureHashTagHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // Button Tap
    @objc func handleCommentTapped() {
        delegate?.handleReplyTapped(self)
    }
    @objc func handleRetweetTapped() {
        print("DEBUG: 리트윗하기")
    }
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
        print("DEBUG: 좋아요")
    }
    @objc func handleShareTapped() {
        print("DEBUG: 공유하기")
    }
    
    // ImageView Tap
    @objc func handleProfileImageTapped() {
        // 여기를 통해서, 
        delegate?.handleProfileImageTapped(self)
    }
    
    // MARK: - Helpers
    func configure() {
        guard let tweet = tweet else {
            return
        }
        captionLabel.text = tweet.caption
        
        let viewModel = TweetViewModel(tweet: tweet)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        infoLabel.attributedText = viewModel.userInfoText
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
    
    func configureMentionHandler() {
        captionLabel.handleMentionTap { mention in
            print("DEBUG: 멘션한 \(mention)(을)를 선택하였습니다.")
            // 연결되어있는 controller에서 pushController를 통해 다른 페이지로 넘어가야한다.
            self.delegate?.handleMentionTapped(self,username: mention)
        }
    }
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    func configureHashTagHandler() {
        captionLabel.handleHashtagTap { hashTag in
            print("DEBUG: 태그한 \(hashTag)(을)를 선택하였습니다.")
            // 연결되어있는 controller에서 pushController를 통해 다른 페이지로 넘어가야한다.
            self.delegate?.handleHashTagTapped(self, username: hashTag)
        }
    }
}
