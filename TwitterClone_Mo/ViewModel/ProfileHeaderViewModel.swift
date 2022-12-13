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
