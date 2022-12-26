//
//  ProfileController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/06.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifire = "ProfileHeader"

class ProfileController: UICollectionViewController {
    // MARK: - Properties
    private var user: User
    
    private var tweets = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }
    // MARK: - Lifectcle
    
    init(user:User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        checkIfUserIsFollowed()
        fetchUserStats()
        
        print("DEBUG: User is \(user.username)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets(user: user) { tweets in
            self.tweets = tweets
        }
    }
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    func fetchUserStats() {
        UserService.shared.fetchUserState(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    // MARK: - Helpers
    func configureCollectionView() {

        
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind:
                                    UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifire)
    }
}
// MARK: - UICollectionViewDataSource 

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifire, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 370)
    }
}
// MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        // 만약 현재 프로필이 내 계정이라면
        if user.isCurrentUser {
            // 향후에, 내 프로필을 수정할 수 있는 페이지를 여기에 설정한다.
            print("DEBUG: Show edit profile controller..")
            return
        }
        // 선택한 계정이 팔로우 되어있을 경우, 이 버튼을 눌렀다는 것은, 이미 팔로우가 되어있는 상태에서, 한 번 더 누른 것이므로, 언팔로우이다.
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { err, ref in
                self.user.isFollowed = false
                self.fetchUserStats()
            }
        }else{
            UserService.shared.followUser(uid: user.uid) { err, ref in
                self.user.isFollowed = true
                self.fetchUserStats()
            }
        }
    }
}
