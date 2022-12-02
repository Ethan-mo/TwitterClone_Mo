//
//  UserService.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/30.
//

import Firebase
struct UserService {
    static let shared = UserService()
    
    // 굳이 매개변수로 completion을 해야하나? 그냥 return으로 User값을 주면, 될텐데
    func fetchUser(completion:@escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            // Ditionary형태로 깔끔하게 정리해서 데이터를 불러오려고 아래와같이 설정하였다.
            guard let dictionaty = snapshot.value as? [String:AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionaty)
            
            print("DEBUG: Username is \(user.username)")
            print("DEBUG: Fullname is \(user.fullname)")
            completion(user)
        }
    } 
}
