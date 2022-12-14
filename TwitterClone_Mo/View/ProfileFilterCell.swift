//
//  ProfileFilterCell.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/12.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    // MARK: - Properties
    var option: ProfileFilterOptions! {
        didSet { titleLabel.text = option.descroption }
    }
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "test"
        return label
    }()
    override var isSelected: Bool {
        didSet{
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? UIColor.twitterBlue : UIColor.lightGray
        }
    }
    
    // MARK: - Liftcycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.center(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
