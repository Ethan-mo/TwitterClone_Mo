//
//  FeedController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/16.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "tweetCell"

protocol FeedControllerDelegate : class {
    func tappedImageView()
}

class FeedController: UICollectionViewController {
    // MARK: - Properties
    
    weak var delegate: FeedControllerDelegate?
    var user: User? {
        // user의 profileImage를 불러와야 가능한 부분이기때문에, didSet을 사용
        didSet{
            print("DEBUG: 정상실행됨")
            configureLeftBarButton()
            
        }
    }
    
    private var tweets = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }

    
    // MARK: - Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTweets()
        collectionView.reloadData()
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    func fetchTweets() {
        collectionView.refreshControl?.beginRefreshing()
            TweetService.shared.fetchTweets { tweets in
                self.tweets = tweets
                self.checkIfUserLikedTweets(tweets)
                
                self.tweets = tweets.sorted(by: { $0.timestamp > $1.timestamp })
                
                self.collectionView.refreshControl?.endRefreshing()
            }
    }
    
    func checkIfUserLikedTweets(_ tweets: [Tweet]) {
        for (index, tweet) in tweets.enumerated() {
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                guard didLike == true else { return }
                self.tweets[index].didLike = didLike
            }
        }
    }
    // MARK: - Selector
    @objc func handleProfileImage() {
        delegate?.tappedImageView()
    }
    @objc func handleRefresh() {
        fetchTweets()
    }
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44) // 이부분은 잘 이해가 되지 않는다. 가운데 정렬도아니고, 가로 세로를 기입해준걸까?
        navigationItem.titleView = imageView
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let iv = UIImageView()
         iv.setDimensions(width: 32, height: 32)
         iv.layer.cornerRadius = 32 / 2
         iv.layer.masksToBounds = true
         
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImage))
         iv.addGestureRecognizer(tap)
         iv.isUserInteractionEnabled = true
         iv.sd_setImage(with: user.profileImageUrl)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iv)
    }
}

// MARK: - UICollectionViewDelegate/DataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        cell.cellCount = indexPath.row
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // feed에 있는 cell을 눌렀을 때, TweetController로 넘어가는데, 해당 파일에 넘어가는 tweet정보는, FeedController tweets안에 담긴 tweet정보를 보내주게된다.
        let controller = TweetController(tweet:tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }

}


// MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        //viewModel에서 높이를 불러온다.
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 72)
    }
}
extension FeedController: TweetCellDelegate {
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
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        TweetService.shared.likeTweet(tweet: tweet) { (err,ref) in
            cell.tweet?.didLike.toggle()
            cell.tweet?.likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1

            
            var tempTweets = self.tweets
            for (index,element) in tempTweets.enumerated() {
                if cell.tweet?.tweetID == element.tweetID {
                    tempTweets[index].likes = cell.tweet?.likes ?? 0
                    tempTweets[index].didLike = cell.tweet?.didLike ?? false
                    self.tweets = tempTweets
                }
            }
            
            guard !tweet.didLike else { return }
            NotificationService.shard.uploadNotification(type: .like, tweet: cell.tweet) // 강의에서는 cell.tweet을 tweet대신 사용했는데, 사실 상관없다.
            // uploadNotification()메서드에서는 사실상 tweet에 있는 user정보와 tweet.tweetID만 필요로 하고, 이를 DB에 저장하기 때문에, like값과 didlike값이 중요하지 않은 상황에서 딱히 cell.tweet을 안써도 된다.
        }
    }

}
