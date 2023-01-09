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
            REF_TWEET_REPLIES.child(tweet.tweetId).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
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
                let tweet = Tweet(user: user, tweetId: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchReplies(tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_TWEET_REPLIES.child(tweet.tweetId).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetId = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
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
            let tweetId = snapshot.key
            
            // Tweets 폴더에서 특정 tweetID에 맞는 Tweets을 불러온다.
            REF_TWEETS.child(tweetId).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String:Any] else { return }
                
                let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
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
