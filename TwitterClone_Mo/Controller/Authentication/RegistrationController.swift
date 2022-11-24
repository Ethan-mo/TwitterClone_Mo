//
//  RegistrationController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/23.
//

import Foundation
import UIKit
class RegistrationController: UIViewController{
    // MARK: - Properties
    private let imagePicker = UIImagePickerController()
    private let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return btn
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textField: emailTextField)
       return view
    }()
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
       return view
    }()
    private lazy var fullNameContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullNameTextField)
       return view
    }()
    private lazy var nickNameContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: nickNameTextField)
       return view
    }()
    private var emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    private var passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "PassWord")
        tf.isSecureTextEntry = true
        return tf
    }()
    private var fullNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Full Name")
        return tf
    }()
    private var nickNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "NickName")
        return tf
    }()
    private var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(UIColor.twitterBlue, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.anchor(paddingTop:40 ,height:50)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    private var alreadyHaveAccountButton: UIButton = {
        let btn = Utilities().button("Already have an account? ", " Sign Up")
        btn.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return btn
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
        // MARK: - Selectors
    @objc func handleAddProfilePhoto(){
        present(imagePicker, animated: true, completion: nil)
    }
    @objc func handleSignUp(){
        print("Press Sign Up Btn!")
    }
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
        // MARK: - Helpers
    func configureUI(){
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.backgroundColor = .twitterBlue
        
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        
        plusPhotoButton.layer.cornerRadius = 64
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,fullNameContainerView,nickNameContainerView,loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton
            .anchor(left:view.leftAnchor,bottom:view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,paddingLeft: 40 ,paddingBottom: 16,paddingRight: 40)
    }
}
// MARK: - UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        plusPhotoButton.layer.cornerRadius = 64
        plusPhotoButton.layer.masksToBounds = true
        
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
}
