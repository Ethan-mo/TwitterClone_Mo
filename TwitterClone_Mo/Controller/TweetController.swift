//
//  TweetController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/27.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifire = "TweetHeader"



class TweetController: UICollectionViewController {
    
    // MARK: - Properties

    private var tweet: Tweet
    private var actionSheetLauncher: ActionSheetLauncher!
    private var replies = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }
    // MARK: - Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    
    
    // MARK: - API
    func fetchReplies() {
        TweetService.shared.fetchReplies(tweet: tweet) { tweets in
            self.replies = tweets
        }
    }
    
    // MARK: - Helper
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind:
                                    UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifire)
    }
    fileprivate func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
}
// MARK: - UICollectionViewDelegate
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifire, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        cell.delegate = self
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: captionHeight + 260)
    }
}

// MARK: - TweetCellDelegate
extension TweetController: TweetCellDelegate {
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        TweetService.shared.likeTweet(tweet: tweet) { (err,ref) in
            cell.tweet?.didLike.toggle()
            // 사실상 TweetService.shared.likeTweet내부에서, DB상의 Likes값이 변경되도록 설정이 되어있다.
            // 아래에서 굳이 cell.tweet의 값을 변경해 주는 이유는 DB에 접근하여 likes값을 가져오지 않고도, 즉각적으로 값을 불러와주기 위해서다.(ex. Like tap시에 빨간색으로 변경하기) 
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
        }
    }
    
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileController(user: user)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: - TweetHeaderDelegate
extension TweetController: TweetHeaderDelegate {
    // tweetHeader에서 [좋아요]버튼을 눌렀을 때 생기는 일
    func handleLikeTapped(_ header:TweetHeader) {
        // 가지고있는 tweet정보에 근거아래 likeTweet()을 실행한다.
        TweetService.shared.likeTweet(tweet: tweet) { (err, ref) in
            // tweet의 didLike값을 스위칭하고, 
            self.tweet.didLike.toggle()
            let likes = self.tweet.didLike ? self.tweet.likes - 1 : self.tweet.likes + 1
            header.tweet?.likes = likes
        }
        
    }
    
    func showActionSheet() {
        if tweet.user.isCurrentUser {
            showActionSheet(forUser: tweet.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
    }
}

// MARK: - ActionSheetLauncherDelegate
extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { (err,ref) in
                print("DEBUG: Follow \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                print("DEBUG: UnFollow \(user.username)")
            }
        case .report:
            print("DEBUG: Report Tweet")
        case .delete:
            // 애초에 delete는 본인에게만 뜨므로, 따로 검증하는 절차는 없어도 된다.
            TweetService.shared.deleteTweet(tweetId: tweet.tweetID) { (err,ref) in
                print("DEBUG: Delete Tweet..")
            }
            
        }
    }
}
