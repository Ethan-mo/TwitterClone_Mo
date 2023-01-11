//
//  FeedController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/16.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "tweetCell"

class FeedController: UICollectionViewController {
    // MARK: - Properties
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
            TweetService.shared.fetchTweets { tweets in
                self.tweets = tweets
                self.checkIfUserLikedTweets(tweets)
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
    
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44) // 이부분은 잘 이해가 되지 않는다. 가운데 정렬도아니고, 가로 세로를 기입해준걸까?
        navigationItem.titleView = imageView
    }
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

// MARK: - UICollectionViewDelegate/DataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DEBUG: 일단 트윗의 숫자는: \(tweets.count)")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
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
        // cell이 가지고있는 tweet 값을 가지고, FB의 DB에 접근한다.
        // 만약, [좋아요]가 false였을 경우,
        /// DB상,
        /// tweet테이블에는 like값을 증가, tweet-likes, user-likes 테이블에는 추가
        /// tweet테이블에는 like값을 감소, tweet-likes, user-likes 테이블에는 삭제
        guard let tweet = cell.tweet else { return }
        TweetService.shared.likeTweet(tweet: tweet) { (err,ref) in
            
            // 여기부터는, [좋아요]표시가 눌렸을 때, 즉각적인 반응을 얻기 위해 작성하는 코드이다.
            /// cell의 tweet값이 변경되면서 didSet이 발동한다.
            cell.tweet?.didLike.toggle()
            cell.tweet?.likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            
            // 문제는 여기서 발생한다. 현재 가지고있는 tweets:[Tweet] 값은 변경되지 않았다.
            // fetchTweets를 실행하면, DB에서 직접 가져오기때문에, 시간은 조금 걸릴지언정, 정확한 값을 가져올 수 있다.
            /// 다른 방법으로, tweets값을 갱신해야한다. 어떻게 가능할까?
            
            var tempTweets = self.tweets
            for (index,element) in tempTweets.enumerated() {
                if cell.tweet?.tweetID == element.tweetID {
                    tempTweets[index].likes = cell.tweet?.likes ?? 0
                    tempTweets[index].didLike = cell.tweet?.didLike ?? false
                    self.tweets = tempTweets
                }
            }
        }
    }

}
