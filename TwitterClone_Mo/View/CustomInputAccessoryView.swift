//
//  CustomInputAccessoryView.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/02/28.
//

import UIKit

class CustomInputAccessoryView: UIView {
    // MARK: - Properties
    private lazy var messageInputTextView: UITextView = {
       let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    private lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("보내기", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(.systemPurple, for: .normal)
        btn.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return btn
    }()
    
    private let placeholderLabel: UILabel = {
       let label = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        // aytoresizingMask는 부모 뷰의 크기가 변경될 때, 자동으로 조정되는 방식을 제어할 때 사용한다.
        // 여기서 .flexibleHeight는 부모 뷰의 높이가 변경될 때, 자동으로 높이가 조정된다.
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        sendButton.setDimensions(width: 50, height: 50)
        
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top:topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 8,paddingRight: 8)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(left: messageInputTextView.leftAnchor, paddingLeft: 4)
        placeholderLabel.centerY(inView: messageInputTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    // MARK: - Selector
    @objc func handleSendMessage() {
        print("DEBUG: 메세지를 전송하였습니다.")
    }
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = messageInputTextView.text.isEmpty ?  false : true
    }
    
    // MARK: - Helper
    
}

