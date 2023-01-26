//
//  EditProfileHeader.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/26.
//

import UIKit
class EditProfileHeader: UIView {
    // MARK: - Properties
    private let user: User
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selector
    // MARK: - API
    // MARK: - Helper
}
