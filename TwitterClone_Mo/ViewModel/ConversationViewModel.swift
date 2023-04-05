//
//  ConversationViewModel.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/04/05.
//

import Foundation
struct ConversationViewModel {
    var conversation: Conversation
    
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
}
