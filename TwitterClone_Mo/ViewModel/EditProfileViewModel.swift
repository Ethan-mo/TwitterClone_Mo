//
//  EditProfileViewModel.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/27.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .fullname: return "Fullname"
        case .username: return "Username"
        case .bio: return "Bio" 
        }
    }
}
