//
//  ExploreController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/16.
//

import UIKit

private let reuseIdentifier = "userCell"
class ExploreController: UITableViewController{
    // MARK: - Properties
    private var users:[User] = [] {
        didSet{ tableView.reloadData() }
    }
    private let searchController = UISearchController(searchResultsController: nil)
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureSearchController()
        fetchUser()
    }
    // MARK: - API
    func fetchUser() {
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    
    // MARK: - Helpers
    func configureTableView() {
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Search"
    }
    func configureSearchController () {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}
extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}
//extension ExploreController: UITableViewDataSource {
//
//}
