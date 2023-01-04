//
//  UploadTweetViewModel.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/04.
//

import UIKit

/// Upload를 하는 2가지 상황
enum UploadTweetConfiguartion {
    case tweet // 일반적인 Tweet
    case reply(Tweet) // 특정 Tweet에 답장을 하는 경우
}
struct UploadTweetViewModel {
    let actionButtonTitle: String // 눌러야하는 버튼의 String값
    let placeholderText: String // 기본적으로 설정되는 PlaceHolder
    let shouldShowReplyLabel: Bool // 현재 상태가 Reply인지 확인하는 값
    var replyText: String? // reply였을 경우, 보여줄 내용
    
    /// 초기화 시, Upload할 때, 확인하는 2가지 경우의 수에 대한 기본 설정값을 세팅한다.
    init(config: UploadTweetConfiguartion) {
        switch config {
            
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's Hapening"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.username)"
        }
    }
}
