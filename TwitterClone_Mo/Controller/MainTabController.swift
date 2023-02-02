//
//  MainTabController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/16.
//

import UIKit
import Firebase

enum tabBarStatusType{
    case tweet
    case message
}

class MainTabController: UITabBarController {
    // MARK: - Properties
    private var currentTabBar: tabBarStatusType = .tweet
    
    var user: User?{
        didSet{
            // 사용자 정보를 정상적으로 불러오면 didSet이 작동한다.
            print("DEBUG: Did set user in main tab..")
            /// viewControllers: navigation controller는 여러개의 view controller를 관리하는 container로,
            /// navigaton stack에 쌓인 view controller들을 viewControllers라고한다.
            /// 우리는 지금, 현재 VC가 아닌, feedVC에 접근해서, 내부 프로퍼티에 접근하고 싶기 때문에, 이러한 과정을 거친다.
            guard let nav = viewControllers?[0] as? UINavigationController else { return } // type은 NSArray
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user =  user
        }
    }

    var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //logUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
        
        
    }
    // MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            // 이 곳(MainTabController)에 user변수에, Firebase통신으로 가져온 user의 정보를 저장한다.
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil{
            print("DEBUG: User is not logged in..")
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }else{
            print("DEBUG: User is logged in..")
            configureViewControllers()
            tabBar.backgroundColor = #colorLiteral(red: 0.9832744988, green: 0.9905122324, blue: 0.9633532572, alpha: 1)
            configureUI()
            fetchUser()
            
        }
    }
    
    func logUserOut(){
        do{
            // 1) 로그아웃
            try Auth.auth().signOut()
            print("DEBUG: logout에 성공하였습니다.")
        }catch let error{
            print("DEBUG: Failed to sign out with error\(error.localizedDescription)")
        }
    }
    
    // MARK: - Selectors
    @objc func actionButtonTapped(){
        guard let user = user else { return }
        var controller: UIViewController
        switch currentTabBar {
        case .tweet:
            controller = UploadTweetController(user: user,config: .tweet)
            print("DEBUG:새로운 트윗 창")
        case .message:
            controller = SearchController(config: .messages)
            print("DEBUG:메세지 전송 창")
        }
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
    // MARK: - Helpers
    func configureUI(){
        self.delegate = self
        
        view.addSubview(actionButton)
        actionButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        
        actionButton.layer.cornerRadius = 56  / 2
        actionButton.backgroundColor = UIColor.mainBlue
    }
    
    func configureViewControllers(){
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        feed.delegate = self
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = SearchController(config: .userSearch)
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        
        let conversations = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        return nav
    }

    func uiTabBarSetting() {
        if #available(iOS 15.0, *){
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UIApplication.shared.statusBarStyle = .lightContent
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }

}
extension MainTabController: FeedControllerDelegate {
    func remoteLogout() {
        logUserOut()
        authenticateUserAndConfigureUI()
    }
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return }
        currentTabBar = (0...2).contains(index) ? .tweet : .message

        let image = currentTabBar == .tweet ? UIImage(named: "new_tweet") : UIImage(named: "mail")
        actionButton.setImage(image, for: .normal)
    }
}
