//
//  UserService.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/30.
//

import Firebase
struct UserService {
    static let shared = UserService()
    
    /// 단 한명의 user의 정보를 호출할 때 사용하는 API
    func fetchUser(uid: String, completion:@escaping(User) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            // Ditionary형태로 깔끔하게 정리해서 데이터를 불러오려고 아래와같이 설정하였다.
            guard let dictionaty = snapshot.value as? [String:AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionaty)
            completion(user)
        }
    }
    /// DB에 있는 모든 user의 정보를 호출할 때 사용하는 API
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let userID = snapshot.key
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            
            let user = User(uid: userID, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
}
