//
//  MainTabController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/16.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
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

    // MARK: - Properties
    let actionButton: UIButton = {
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
        UserService.shared.fetchUser { user in
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
            try Auth.auth().signOut()
            print("DEBUG: logout에 성공하였습니다.")
        }catch let error{
            print("DEBUG: Failed to sign out with error\(error.localizedDescription)")
        }
    }
    
    // MARK: - Selectors
    @objc func actionButtonTapped(){
        // user가 nil이 아닌지 확인
        guard let user = user else { return }
        // UploadTweetController에 Data를 전달하기위해 user를 매개변수로 하는 생성자로 초기화
        let controller = UploadTweetController(user: user)
        // 새로운 NavigationController를 만들려고하는데, 위에서 생성자 매개변수를 넣어주듯, 새로운 네비게이션 컨트롤러에는 RootVC가 뭔지 설정해주는 것이 필요하다.
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        // present는 pushViewController와는 다르게 새로 띄우는거다. 크롬으로 비유하자면, [새탭추가]가 아니라, [새창띄우기]
        present(nav,animated: true,completion: nil)
    }
    // MARK: - Helpers
    func configureUI(){
        view.addSubview(actionButton)
        actionButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        
        actionButton.layer.cornerRadius = 56  / 2
        actionButton.backgroundColor = UIColor.mainBlue
    }
    
    func configureViewControllers(){
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
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
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }

}
