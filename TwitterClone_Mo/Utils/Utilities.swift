//
//  Utilities.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/24.
//

import UIKit
class Utilities{
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView{
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.image = image
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left:iv.rightAnchor,bottom: view.bottomAnchor, right: view.rightAnchor,paddingLeft: 8,paddingBottom: 8)
        
        let lineView = UIView()
        lineView.backgroundColor = .white
        view.addSubview(lineView)
        lineView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,paddingLeft: 8,paddingRight: 20, height: 0.6)
        return view
    }
    func textField(withPlaceholder placeholder: String) -> UITextField{
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }
    func button(_ descriptionLabel: String, _ title: String) -> UIButton{
        let btn = UIButton(type: .system)
        
        /// 하이퍼링크 라벨형 버튼 제작
        let attributedTitle = NSMutableAttributedString(string: descriptionLabel, attributes: [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSMutableAttributedString(string: title, attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: UIColor.white]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        return btn
    }
}
