//
//  UserService.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/30.
//

import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)
struct UserService {
    static let shared = UserService()
    
    /// 단 한명의 user의 정보를 호출할 때 사용하는 API
    func fetchUser(uid: String, completion:@escaping(User) -> Void) {
        // 1) 데이터를 1차례 조회할 때 사용하는 observeSingleEvent() 메서드를 활용한다.
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
        // 1) 데이터를 특정한 조건에 True일 때마다 조회할 때 사용하는 observe() 메서드를 활용한다.
        REF_USERS.observe(.childAdded) { snapshot in
            let userID = snapshot.key
            // Ditionary형태로 깔끔하게 정리해서 데이터를 불러오려고 아래와같이 설정하였다.
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            
            let user = User(uid: userID, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    // 내가 추가로 다른사람을 팔로우
    func followUser(uid: String, completion: @escaping DatabaseCompletion) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        // 1) child(currenUid)에 접근 가능한 DB Reference 인스턴스를 생성하고, 내부 메서드인 .updateChildValues()를 통해 데이터를 생성한다.
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { err, ref in
            // 2) child(uid)에 접근 가능한 DB Reference 인스턴스를 생성하고, 내부 메서드인 .updateChildValues()를 통해 데이터를 생성한다.
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    // 기존 팔로워를 끊을 때
    func unfollowUser(uid: String, completion: @escaping DatabaseCompletion ) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        // 1) child(currenUid).child(uid)에 접근 가능한 DB Reference 인스턴스 생성하고, 내부 메서드인 .removeValue()를 통해 데이터를 삭제한다.
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { err,ref in
            // 2) child(uid).child(currenUid)에 접근 가능한 DB Reference 인스턴스를 생성하고, 내부 메서드인 .removeValue()를 통해 데이터를 삭제한다.
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    func checkIfUserIsFollowed(uid: String, completion:@escaping (Bool) -> Void) {
        // user-followers를 호출하고, 이미 있는 uid라면, user의 isFollowed의 값을 true로 설정
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
            
        }
    }
    func fetchUserState(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    func saveUserData(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["fullname": user.fullname,
                      "username": user.username,
                      "bio": user.bio ?? ""]
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        
    }
}
