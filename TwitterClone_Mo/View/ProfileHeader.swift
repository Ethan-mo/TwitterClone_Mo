//
//  ProfileHeader.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/07.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .twitterBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
