//
//  EditProfileController.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/01/26.
//

import UIKit
private let reusableIdentifier = "EditProfileCell"

// 내용이 변경되었을 때, 실질적인 ProfileController에 속성값도 변경시켜 주기 위해 프로토콜을 작성한다.
protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
}

class EditProfileController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // MARK: - Properties
    private var user: User
    private lazy var headerView = EditProfileHeader(user: user)
    private let imagePicker = UIImagePickerController()
    weak var delegate: EditProfileControllerDelegate?
    
    private var imageChanged: Bool {
        return selectedImage != nil
    }
    
    private var userInfoChanged = false
    
    private var selectedImage: UIImage? {
        didSet {headerView.profileImageView.image = selectedImage }
    }
    
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
        configureImagePicker()
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
        view.endEditing(true)
        guard imageChanged || userInfoChanged else { return }
        updateUserData()
    }
    // MARK: - API
    /// 강의에서와는 다르게, 하나의 함수가 하나의목적을 갖도록 변경하였다.
    func updateUserData() {
        if imageChanged && userInfoChanged {
            updateUserInfo()
            updateProfileImage()
        }
        
        if imageChanged && !userInfoChanged {
            updateProfileImage()
        }
        
        if !imageChanged && userInfoChanged {
            updateUserInfo()
        }
        if !imageChanged && !userInfoChanged {
            print("DEBUG: 아무 정보도 변경되지 않았습니다.")
        }
    }
    func updateUserInfo() {
        UserService.shared.saveUserData(user: user) { err, ref in
            print("DEBUG: 유저 정보가 갱신되었습니다.")
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    func updateProfileImage() {
        guard let image = selectedImage else { return }
        UserService.shared.updateProfileImage(image: image) { imageUrlString in
            print("DEBUG: 유저의 프로필 사진이 갱신되었습니다.")
            self.user.profileImageUrl = URL(string: imageUrlString)
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
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
        
    }
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = UIView()
        headerView.delegate = self
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reusableIdentifier)
        
    }
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
}

// MARK: - UITableViewDataSource
extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier , for: indexPath) as! EditProfileCell
        cell.delegate = self
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 100 : 48
    }
}

// MARK: - EditProfileHeaderDelegate
extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("DEUBG: 프로필 사진을 업데이트 하였습니다.")
        
        guard let image = info[.editedImage] as? UIImage else { return }
        selectedImage = image
        // 여기서 서버에 있는 user정보에 url을 변경한다. storage도 건든다는 사실을 알고가자
        dismiss(animated: true)
    }
}
// MARK: - EditProfileCellDelegate
extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        //여기서는 실질적인(서버) User Data를 수정한다.
        
            
        guard let viewModel = cell.viewModel else { return }
        switch viewModel.option {
        case .fullname:
            print("DEBUG: fullname에 들어있는 fullname값은~\(cell.infoTextFeild.text)")
            guard let fullname = cell.infoTextFeild.text else { return }
            userInfoChanged = fullname != user.fullname ? true : false
            user.fullname = fullname
        case .username:
            print("DEBUG: username에 들어있는 username값은~\(cell.infoTextFeild.text)")
            guard let username = cell.infoTextFeild.text else { return }
            userInfoChanged = username != user.username ? true : false
            user.username = username
        case .bio:
            print("DEBUG: cell에 들어있는 bio값은~\(cell.bioTextView.text)")
            guard let userBio = cell.bioTextView.text else { return }
            userInfoChanged = userBio != user.bio ? true : false
            user.bio = cell.bioTextView.text
        }
        
        print("DEBUG: 현재 Fullname \(user.fullname)")
        print("DEBUG: 현재 Username \(user.username)")
        print("DEBUG: Bio is \(user.bio)")

    }
    
}
