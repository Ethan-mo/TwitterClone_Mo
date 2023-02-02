//
//  NotificationService.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/13.
//

import Foundation
import Firebase

struct NotificationService {
    
    static let shard = NotificationService()
    func uploadNotification(toUser user: User, type:NotificationType, tweetID: String? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        if let tweetID = tweetID { values["tweetID"] = tweetID }
        REF_NOTIFICATION.child(user.uid).childByAutoId().updateChildValues(values)
    }
///    // 매개변수로 1. 알람 타입, 2. 트윗정보, 3. 유저정보
//    func uploadNotification2(type:NotificationType, tweet: Tweet? = nil, user: User? = nil) {
///        // 현재 접속해있는 유저의 uid불러오기
//        guard let uid = Auth.auth().currentUser?.uid else { return }
///        // 알람의 기본 내용(values)을 세팅해주는 작업
//        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
//                                     "uid": uid,
//                                     "type": type.rawValue]
///        // 만약 tweet의 내용이 있을 경우, values값에 "tweetID"도 추가해준다.
//        if let tweet = tweet {
//            values["tweetID"] = tweet.tweetID
///            // user정보도 있고, uid도 있지만, 굳이 tweet에 있는 user의 uid를 구해주었다.
//            REF_NOTIFICATION.child(tweet.user.uid).childByAutoId().updateChildValues(values)
//        }
//        if let user = user {
//            REF_NOTIFICATION.child(user.uid).childByAutoId().updateChildValues(values)
//        }
//    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 여기에 우선 알람이 있는지 없는지를 판단하는 코드를 넣어 주어야한다.
        REF_NOTIFICATION.child(uid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                print("DEBUG: 현재 비어있습니다. ")
                completion(notifications)
            }
        }
        
        REF_NOTIFICATION.child(uid).observe(.childAdded) { snapShot in
            guard let dictionary = snapShot.value  as? [String:AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
            
        }
    }
}
