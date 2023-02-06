//
//  ConversationsController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/16.
//
import UIKit

class ConversationsController: UIViewController{
    // MARK: - Properties
    var user: User? {
        // user의 profileImage를 불러와야 가능한 부분이기때문에, didSet을 사용
        didSet{
            print("DEBUG: \(user)")
            print("DEBUG: 메세지에서 정상실행됨")
            configureLeftBarButton()
            
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        configureNavigationBar()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK: - Selector
    @objc func handleProfileImage() {
        print("DEBUG: 짜잔~")
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .twitterBlue
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        print("DEBUG: 현재 user값은: \(user)")
        
        let iv = UIImageView()
         iv.setDimensions(width: 32, height: 32)
         iv.layer.cornerRadius = 32 / 2
         iv.layer.masksToBounds = true
        iv.sd_setImage(with: user.profileImageUrl)
         
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImage))
         iv.addGestureRecognizer(tap)
         iv.isUserInteractionEnabled = true
         
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iv)
    }
    
}
