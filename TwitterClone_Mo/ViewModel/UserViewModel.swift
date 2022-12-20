//
//  UserViewModel.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/20.
//

import UIKit
struct UserViewModel {
    let user: User
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    init(user: User) {
        self.user = user
    }
}
