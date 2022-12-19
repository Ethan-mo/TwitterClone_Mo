//
//  ProfileHeaderViewModel.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/13.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    var descroption: String{
        switch self{
        case .tweets: return "Tweets"
        case .replies: return "Tweets & replies"
        case .likes: return "Likes"
        }
    }
}
struct ProfileHeaderViewModel {
    private let user: User
    let userNameText: String
    
    var following:NSAttributedString {
        return attributedText(withValue: 2, text: "following")
    }
    var followers:NSAttributedString {
        return attributedText(withValue: 0, text: "followers")
    }
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }else{
            return "Follow"
        }
    }
    
    init(user: User) {
        self.user = user
        self.userNameText = "@" + user.username
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value) ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
