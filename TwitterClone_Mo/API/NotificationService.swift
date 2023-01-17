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
    
    func uploadNotification(type:NotificationType, tweet: Tweet? = nil, user: User? = nil) {
        print("DEBUG: 이렇게 알람이 가는 겁니다.")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            REF_NOTIFICATION.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        }
        if let user = user {
            REF_NOTIFICATION.child(user.uid).childByAutoId().updateChildValues(values)
        }
    }
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
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
