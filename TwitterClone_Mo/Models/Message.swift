//
//  Message.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/03/02.
//

import UIKit
import Firebase

struct Message {
    let text: String
    let toID: String
    let fromID: String
    var timestamp: Timestamp!
    var user: User?
    
    let isFromCurrentUser: Bool
    
    var chatToId: String {
        return isFromCurrentUser ? toID : fromID
    }
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toID = dictionary["toId"] as? String ?? ""
        self.fromID = dictionary["fromId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromID == Auth.auth().currentUser?.uid ? true : false
    }
}

struct Conversation {
    var user: User
    var message: Message
}
