//
//  TweetService.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/02.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["uid" : uid,
                      "timestamp" : Int(NSDate().timeIntervalSince1970),
                      "likes" : 0,
                      "retweets" : 0,
                      "caption" : caption] as [String : Any]
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
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
