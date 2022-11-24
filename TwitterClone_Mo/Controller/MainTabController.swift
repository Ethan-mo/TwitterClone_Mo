//
//  MainTabController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/16.
//

import UIKit

class MainTabController: UITabBarController {

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
        configureViewControllers()
        tabBar.backgroundColor = #colorLiteral(red: 0.9832744988, green: 0.9905122324, blue: 0.9633532572, alpha: 1)
        configureUI()
        
    }
    // MARK: - Selectors
    @objc func actionButtonTapped(){
        print(123)
    }
    // MARK: - Helpers
    func configureUI(){
        view.addSubview(actionButton)
        actionButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        
        actionButton.layer.cornerRadius = 56  / 2
        actionButton.backgroundColor = UIColor.mainBlue
    }
    
    func configureViewControllers(){
        let feed = FeedController()
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
