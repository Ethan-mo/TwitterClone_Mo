//
//  UserService.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/30.
//

import Firebase
struct UserService {
    static let shared = UserService()
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            // Ditionary형태로 깔끔하게 정리해서 데이터를 불러오려고 아래와같이 설정하였다.
            guard let dictionaty = snapshot.value as? [String:AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionaty)
            
            print("DEBUG: Username is \(user.username)")
            print("DEBUG: Fullname is \(user.fullname)")
        }
    }
}
