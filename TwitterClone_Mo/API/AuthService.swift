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
        // 1) 파라미터로 가져온 Data를 signIn()메서드에 삽입한다.
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    // reference()는 현재 App에서 발생한 특정 Data를 Firebase의 Database에 저장
    // Child는 폴더와 같은 역할, 이를 통해서 DB상에 User폴더안에 특정 uid별로 DB가 저장된다.
    
    func registerUser(credentials:AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void){
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        let profileImage = credentials.profileImage
        
        // 1) 이미지 파일을 jpegData 형식으로 변경하는 과정
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        // 2) 임의의 Filename을 생성하는 과정
        let filename = NSUUID().uuidString
        // 3) Storage에 특정 위치와 특정이름을 갖는 reference 인스턴스를 생성한다.
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        // 4) 특정 위치에 image Data저장하기
        storageRef.putData(imageData,metadata: nil){ (meta, error) in
            // 5) 저장된 Image Data를 다운로드 받을 수 있는 Url을 불러온다.
            storageRef.downloadURL { (url,error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                // 1) 새로운 계정을 생성한다. 트위터 클론강의에서는 email과 password만 사용하였다.
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error{
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    // 1) RealTime Database에 들어갈 value를 생성
                    let values = ["email": email,
                                  "username": username,
                                  "fullname": fullname,
                                  "profileImageUrl":profileImageUrl]
                    // 2) 회원가입 인증으로 생성된 계정의 uid를 불러오고, 해당 uid를 가진 User Data에 접근하는 Reference인스턴스를 통해 Data를 저장한다.
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
