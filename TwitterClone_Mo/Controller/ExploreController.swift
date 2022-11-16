//
//  ExploreController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/16.
//

import UIKit
class ExploreController: UIViewController{
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Search"
    }
    
}
