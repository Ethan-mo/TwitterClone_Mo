//
//  AuthService.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/28.
//

import Foundation
import Firebase

struct AuthCredentials{
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService{
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        // 분명 위에 AuthCredentials struct가 있지만, 우리에게는 email과 password만 필요하니....
        print("DEBUG: Email is \(email), password is \(password)")
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials:AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void){
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        let profileImage = credentials.profileImage
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        storageRef.putData(imageData,metadata: nil){ (meta, error) in
            storageRef.downloadURL { (url,error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error{
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                    // Database.database()는 Firebase의 realTime Database에 접근
                    // reference()는 현재 App에서 발생한 특정 Data를 Firebase의 Database에 저장
                    // Child는 폴더와 같은 역할, 이를 통해서 DB상에 User폴더안에 특정 uid별로 DB가 저장된다.
                    guard let uid = result?.user.uid else { return }
                    let values = ["email": email,
                                  "username": username,
                                  "fullname": fullname,
                                  "profileImageUrl":profileImageUrl]
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
