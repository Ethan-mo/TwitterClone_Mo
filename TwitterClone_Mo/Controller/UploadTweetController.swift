//
//  UploadTweetController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/01.
//

import UIKit
import SDWebImage

class UploadTweetController: UIViewController {
    // MARK: - Properties
    var user : User
    private let config: UploadTweetConfiguartion
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    // lazy로 처리해줘야, actionButton이 호출될 때 초기화를한다.
    /// 아래에서는, addTarget의 첫번째 매개변수인 self가 의미하는 viewController가 아직 초기화 된 상태가 아니기때문에,
    /// lazy가 아닐 시 addTarget(nil, action: #selector(handleUploadTweet), for: .touchUpInside)로 변형되어 실행된다.
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        
        return button
    }()
    // replyLabel은 UploadTweetController에서, reply모드일떄만 활성화하는 Label이다.
    private lazy var replyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "replying to @spiderman"
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let captionTextView = CaptionTextView()
    
    // MARK: - Lifecycle
    init(user: User, config: UploadTweetConfiguartion) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil) 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, type: config) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload tweet with \(error.localizedDescription)")
                return
            }
            if case .reply(let tweet) = self.config {
                NotificationService.shard.uploadNotification(type: .reply, tweet: tweet)
            }
            
            print("DEBUG: Tweet did upload to database...")
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        // profileImageView와 captionTextView를 묶어서 horizontal형식으로 묶인 스택뷰
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView,captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        // 위에서 정의된 스택뷰와 reply모드에서만 사용한다는 ReplyLabel을 Vertical형태로 스택을 만든다.
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor ,right: view.rightAnchor  ,paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        // actionButton은 현재 Controller에서 사용하는 완료 버튼이다.
        /// viewModel에서는 각 모드(.Tweet | .Reply)에 따라서 actionButtonTitle, placeholderLabel, shouldShowReplyLabel, replyText 값이 각 모드에 맞게 초기화 되어있다.
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        
        // 여기서 중요한 것은, stack의 요소로 사용되고있는 replyLabel이 Hidden상태가 되면, 다른 요소값들이 그 자리를 채워준다.
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        UIApplication.shared.statusBarStyle = .darkContent
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        /// 투명 반투명 관련된 ...?
        //navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}
