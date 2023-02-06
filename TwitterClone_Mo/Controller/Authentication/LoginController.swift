//
//  File.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/23.
//

import UIKit
class LoginController: UIViewController{
    // MARK: - Properties
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "twitter_logo_blue")
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textField: emailTextField)
       return view
    }()
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
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
    private var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.setTitle("Log in", for: .normal)
        btn.setTitleColor(UIColor.twitterBlue, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.anchor(paddingTop:40 ,height:50)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    private var dontAccountButton: UIButton = {
        let btn = Utilities().button("Don't have an account? ", " Sign Up")
        btn.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return btn
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
        // MARK: - Selectors
    @objc func handleLogin(){
        print("Handle ShowSighUp")
        guard let email = emailTextField.text else { return print("DEBUG: Please enter your email") }
        guard let password = passwordTextField.text else { return print("DEBUG: Please enter your password") }
        showLoader(true, withText: "Logging in")
        AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error logging in \(error.localizedDescription)")
                self.showLoader(false)
                return
            }
            print("DEBUG: Successful log in ..")
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
            guard let tab = window.rootViewController as? MainTabController else { return }
            tab.authenticateUserAndConfigureUI()
            self.showLoader(false)
            self.dismiss(animated: true)
        }
    }
    @objc func handleShowSignUp(){
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
        // MARK: - Helpers
    func configureUI(){
        //view.backgroundColor = .twitterBlue
        configureGradientLayer()
        
        /// NavigationController에 대한 Setting
        navigationController?.navigationBar.barStyle = .black // 이부분을 통해, 디바이스 가장 위 상태버튼들의 색상이 흰색으로 바뀐다.(네비게이션 바가 검은색이니, 대비되게 흰색으로 바뀌는 것)
        navigationController?.navigationBar.isHidden = true
        
        /// 이 VC에 추가할 SubView
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontAccountButton)
        dontAccountButton.anchor(left:view.leftAnchor,bottom:view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,paddingLeft: 40 ,paddingBottom: 16,paddingRight: 40)
    }
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.twitterBlue.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

