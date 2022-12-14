//
//  TweetService.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/02.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String,type: UploadTweetConfiguartion, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["uid" : uid,
                      "timestamp" : Int(NSDate().timeIntervalSince1970),
                      "likes" : 0,
                      "retweets" : 0,
                      "caption" : caption] as [String : Any]
        switch type{
        case .tweet:
            REF_TWEETS.childByAutoId().updateChildValues(values) { err, ref in
                guard let tweetID = ref.key else { return }
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        }
    }
    func deleteTweet(tweetId:String, completion: @escaping(DatabaseCompletion)) {
        REF_TWEETS.child(tweetId).removeValue(completionBlock: completion)
        
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchReplies(tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    /**
     Tweets을 불러오는 메서드로, 기존 fetchTweets()과는 다르게, user를 매개변수로 받아서, 해당 user정보에 들어있는 uid를 통해 해당 사용자가 작성한 Tweets을 불러온다.
     */
    func fetchTweets(user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        // User-Tweets에서 특정 사용자가 작성한 Tweets의 고유 ID들을 가져온다.
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            // Tweets 폴더에서 특정 tweetID에 맞는 Tweets을 불러온다.
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String:Any] else { return }
                
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    /// 트윗을 좋아요 했을 때
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        // 현재 나의 uid를 구해주기 위해 아래와 같은 절차를 거친다.
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLike {
            // unlike tweet
            REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { (err,ref) in
                REF_TWEET_LIKES.child(tweet.tweetID).child(uid).removeValue(completionBlock: completion)
            }
        } else {
            // like tweet
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID: 1]) { (err,ref) in
                REF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    /// 트윗의 내용이 변경 되었을 때
    func updateTweet(tweet:Tweet, completion: @escaping(DatabaseCompletion)) {
        let values = ["uid" : tweet.uid,
                      "timestamp" : tweet.timestamp,
                      "likes" : tweet.likes,
                      "retweets" : tweet.retweetCount,
                      "caption" : tweet.caption] as [String : Any]
        REF_TWEETS.child(tweet.tweetID).updateChildValues(values, withCompletionBlock: completion)
    }
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_LIKES.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
}
// Firebase 관련 메서드 정리
/// func observe() : 호출
/// func observeSingleEvent() : 한 번 호출
// 이벤트 타입
/// value : 데이터 전체를 가지고 온다.
/// childAdded: 노드에서부터 추가되는 데이터를 감지한다.
/// childRemoved: 노드에서부터 삭제되는 데이터를 감지한다.
/// childChanged: 노드에서부터 변경되는 데이터를 감지한다.
/// childMoved: 노드에서부터 이동하는 데이터를 감지한다.
