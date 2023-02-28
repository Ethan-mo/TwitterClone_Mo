//
//  ExploreController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/16.
//

import UIKit

private let reuseIdentifier = "userCell"

protocol SearchControllerDelegate: class {
    func controller(_ controller: SearchController, wantsToChatUser user : User)
}

enum SearchControllerConfiguration {
    case messages
    case userSearch
    
}

class SearchController: UITableViewController{
    // MARK: - Properties
    
    private let config: SearchControllerConfiguration
    
    weak var delegate: SearchControllerDelegate?
    
    private var users:[User] = [] {
        didSet{ tableView.reloadData() }
    }
    private var filteredUsers = [User]() {
        didSet{ tableView.reloadData() }
    }
    
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    // MARK: - Lifecycle
    init(config: SearchControllerConfiguration) {
        self.config = config
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureSearchController()
        fetchUser()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .darkContent
        navigationController?.navigationBar.isHidden = false
    }
    // MARK: - API
    func fetchUser() {
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    // MARK: - Selector
    @objc func hanldeDismissal() {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    func configureTableView() {
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = config == .userSearch ? "Search" : "메세지 보낼 대상"
        
        if config == .messages {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(hanldeDismissal))
        }
    }
    func configureSearchController () {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}
// MARK: - UITableViewDelegate/DataSource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUsers.count : users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row] 
        delegate?.controller(self, wantsToChatUser: user)
    }
}
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter { $0.username.contains(searchText) || $0.fullname.contains(searchText)}
    }
}
