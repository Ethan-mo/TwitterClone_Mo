//
//  ActionSheetCell.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/05.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    // MARK: - 속성
    
    var option: ActionSheetOptions? {
        didSet {
            configure()
        }
    }
    
    private let optionImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "twitter_logo_blue")
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "test Option "
        return label
    }()
    
    
    // MARK: - 생명주기
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [optionImageView, titleLabel])
        stack.spacing = 8
        stack.axis = .horizontal
        optionImageView.setDimensions(width: 36, height: 36)
        
        addSubview(stack)
        stack.centerY(inView: self)
        stack.anchor(left: leftAnchor, paddingLeft: 8)
        
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func configure() {
        titleLabel.text = option?.description
    }
}
