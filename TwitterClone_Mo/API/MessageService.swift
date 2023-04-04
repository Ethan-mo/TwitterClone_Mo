//
//  File.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2023/04/04.
//

import Foundation
import Firebase
struct MessageService {
    static func fetchMessage(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let query = FS_MESSAGE.document(currentUid).collection(user.uid).order(by: "timestamp")
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let data = ["text": message, "fromId": currentUid, "toId": user.uid, "timestamp": Timestamp(date: Date())] as [String : Any]
        FS_MESSAGE.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            if user.uid == currentUid {
                return
            }
            FS_MESSAGE.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
        }
    }
}
