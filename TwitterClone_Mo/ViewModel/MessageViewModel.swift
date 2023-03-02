//
//  MessageViewModel.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/03/02.
//

import UIKit

struct MessageViewModel {
    var message: Message
    
    var isTextBackgroundColor: UIColor {
        return message.isCurrentUser ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : .systemPurple
    }
    var isTextColor: UIColor {
        return message.isCurrentUser ? .black : .white
    }
    var bubbleLeftAnchor: Bool {
        return !message.isCurrentUser
    }
    var bubbleRightAnchor: Bool {
        return message.isCurrentUser
    }
    var isProfileImage: Bool {
        return message.isCurrentUser
    }
    init(message: Message) {
        self.message = message
    }
}
