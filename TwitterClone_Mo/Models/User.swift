//
//  User.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/30.
//

import UIKit
import Firebase


struct User {
    var fullname: String
    let email: String
    var username: String
    var profileImageUrl: URL?
    let uid: String
    var isFollowed = false
    var stats: UserRelationStats? // 사용자 정보를 불러온 후에, 값을 초기화 해줄 수 있기 때문에, 옵셔널이다.
    var bio: String?
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid} 
    
    init(uid:String,dictionary: [String: AnyObject]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? " - "
        
        if let bio = dictionary["bio"] as? String {
            self.bio = bio
        }
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
