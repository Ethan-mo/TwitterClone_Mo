//
//  ActionSheetViewModel.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/05.
//

import UIKit

struct ActionSheetViewModel {
    
    private let user: User
    
    var options: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        
        // 만약 선택되어있는 사용자가, 현재 사용자라면 delete Option이 뜨도록
        if user.isCurrentUser {
            results.append(.delete)
        }
        else {
            // 선택한 유저를 내가 팔로우 한 상태이면, UnFollow Option이 뜨도록, 아니라면 Follow Option이 뜨도록
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        
        // 기본적으로 모든 사용자에 뜨는 기능인 Report Option이 뜨도록
        results.append(.report)
        return results
    }
    
    init(user: User) {
        self.user = user
    }
}
enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
            
        case .follow(let user): return "Follow @\(user.username)"
        case .unfollow(let user): return "Unfollow @\(user.username)"
        case .report: return "Repoer Tweet"
        case .delete: return "Delete Tweet"
        }
    }
}
