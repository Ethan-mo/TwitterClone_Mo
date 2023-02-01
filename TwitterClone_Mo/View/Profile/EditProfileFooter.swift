//
//  EditProfileFooter.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/31.
//

import UIKit

protocol EditProfileFooterDelegate: class {
    func handleLogoutButtonTapped()
}

class EditProfileFooter: UIView {
    // MARK: - Properties
    weak var delegate: EditProfileFooterDelegate?
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()

    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingLeft: 48, paddingBottom: 60, paddingRight: 48)
        logoutButton.heightAnchor.constraint(equalToConstant: 50)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    @objc func handleLogout() {
        //버튼을 누르면 로그아웃된다.
        delegate?.handleLogoutButtonTapped()
        print("DEBUG: 로그아웃되었습니다.")
    }
    
    // MARK: - Helper

}
