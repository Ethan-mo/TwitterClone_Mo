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
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { err, ref in
                self.user.isFollowed = false
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
            }
        }else{
            UserService.shared.followUser(uid: user.uid) { err, ref in
                self.user.isFollowed = true
                header.editProfileFollowButton.setTitle("Following", for: .normal)
            }
        }
    }
}
