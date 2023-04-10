//
//  ConversationsController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/16.
//
import UIKit

private let reuseIdentifier: String = "ConversationCell"

protocol ConversationControllerDelegate : class {
    func remoteLogout()
}

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
    var conversations = [Conversation]() {
        didSet{
            tableView.reloadData()
        }
    }
    var conversationsDictionary = [String : Conversation]()
    private let tableView = UITableView()
    weak var delegate:ConversationControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        configureUI()
        fetchConversation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Selector
    @objc func handleProfileImage() {
        print("DEBUG: 짜잔~")
        guard let user = user else { return }
        let controller = ProfileController(user: user)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    // MARK: - API
    func fetchConversation() {
        MessageService.fetchConversations { conversations in
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationsDictionary[message.chatToId] = conversation // Dictionary에 데이터를 추가
            }
            self.conversations = Array(self.conversationsDictionary.values)
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureTableView()
        
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier:  reuseIdentifier)
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
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
    
    func showChatController(_ user: User) {
        let controller = ChatController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
}

extension ConversationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: 선택했습니다.\(indexPath.row)")
        let user = conversations[indexPath.row].user
        showChatController(user)
    }
}
extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
}
extension ConversationsController: ProfileControllerDelegate {
    func remoteLogout() {
        print("DEBUG: remoteLogout()이 실행됨")
        delegate?.remoteLogout()
    }
}
