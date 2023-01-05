//
//  ActionSheetLauncher.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/05.
//

import Foundation
import UIKit

private let reuseIdentifier = "ActionSheetCell"

class ActionSheetLauncher: NSObject {
    // MARK: - 속성
    private let user: User
    private let tableView = UITableView()
    private var window: UIWindow?
    
    private lazy var blackView: UIView = {
       let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UIGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    // MARK: - 생명주기
    init(user: User) {
        self.user = user
        super.init()
        configureTableView()
    }
    // MARK: - Helpers
    func show() {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        // 이렇게만 설정하면, 화면에 없는 아래부분에 tableView가 생성된다.
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 300)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            // 아래 내려가있는 tableView의 y좌표를 변경한다.
            self.tableView.frame.origin.y -= 300
        }
    }
    func configureTableView() {
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        // 테이블뷰안에 있는 각 cell의 높이
        tableView.rowHeight = 60
        // separator은 각 cell 사이의 선을 의미하며, separatorStyle은 선의 스타일을 의미한다.
        tableView.separatorStyle = .none
        // 모서리가 둥근 정도
        tableView.layer.cornerRadius = 5
        // 스크롤이 되는지 여부
        tableView.isScrollEnabled = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    // MARK: - Selector
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
    }
}
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
}

extension ActionSheetLauncher: UITableViewDelegate {
    
}

