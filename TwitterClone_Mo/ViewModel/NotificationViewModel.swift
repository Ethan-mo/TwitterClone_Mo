//
//  NotificationViewModel.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/17.
//

import UIKit

struct NotificationViewModel {
    // MARK: - Properties
    private let notification: Notification
    private let user: User
    private var notificationType: NotificationType
    private var notificationMessage: String {
        switch notificationType{
        case .follow: return "님이 당신을 팔로우 했습니다."
        case .like: return "님이 당신의 트윗을 좋아요 했습니다."
        case .reply: return "님이 당신의 트윗에 댓글을 달았습니다."
        case .retweet: return "님이 당신의 트윗을 리트윗했습니다."
        case .mention: return "님이 당신의 트윗에 멘션을 달았습니다."
        }
    }
    private var timestamp:String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "2m"
    }

    var notificationText: NSAttributedString? {
        guard let timestamp = timestamp else { return nil }

        let atrributedText = NSMutableAttributedString(string: user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        atrributedText.append(NSAttributedString(string: notificationMessage, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        atrributedText.append(NSAttributedString(string: " ・ \(timestamp)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray ]))
        
        return atrributedText
    }
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var shouldHideFollowButton: Bool {
        return notificationType != .follow
    }
    
    var followButtonText: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    // MARK: - LifeCycle
    init(notification:Notification){
        self.notification = notification
        self.notificationType = notification.type
        self.user = notification.user
        
    }
}
