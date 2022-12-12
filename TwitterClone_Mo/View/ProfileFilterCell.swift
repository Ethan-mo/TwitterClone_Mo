//
//  ProfileFilterCell.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/12.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    // MARK: - Properties
    
    // MARK: - Liftcycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .twitterBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
