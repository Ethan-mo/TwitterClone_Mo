//
//  FeedController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/16.
//

import UIKit
import SDWebImage

class FeedController:UIViewController{
    // MARK: - Properties
    var user: User? {
        // user의 profileImage를 불러와야 가능한 부분이기때문에, didSet을 사용
        didSet{
            print("DEBUG: 정상실행됨")
            configureLeftBarButton()
            
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44) // 이부분은 잘 이해가 되지 않는다. 가운데 정렬도아니고, 가로 세로를 기입해준걸까?
        navigationItem.titleView = imageView
    }
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
