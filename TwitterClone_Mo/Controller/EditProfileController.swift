//
//  EditProfileController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/26.
//

import UIKit
private let reusableIdentifier = "EditProfileCell"
class EditProfileController: UITableViewController {
    // MARK: - Properties
    private let user: User
    private lazy var headerView = EditProfileHeader(user: user)
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    @objc func handleDone() {
        dismiss(animated: true)
    }
    // MARK: - API
    // MARK: - Helpers
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .twitterBlue
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .twitterBlue // Tint색상 변경
            appearance.titleTextAttributes = [.foregroundColor:UIColor.white] // Title색상 변경
            
            
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            UIApplication.shared.statusBarStyle = .lightContent
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
            
        }

        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "프로필 수정"

        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = UIView()
        headerView.delegate = self
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reusableIdentifier)
        
    }
    
}
extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier , for: indexPath) as! EditProfileCell
        return cell
    }
}
extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 100 : 48
    }
}

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        print("DEBUG: 실행~")
    }
}
