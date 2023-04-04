//
//  Constants.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/11/26.
//

import Firebase

// Storage에서 데이터를 읽거나 쓰려면 StorageReference의 인스턴스가 필요하다.
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

// 데이터베이스에서 데이터를 읽거나 쓰려면 DatabaseReference의 인스턴스가 필요하다.
let DB_REF = Database.database().reference()
let FS_REF = Firestore.firestore().collection("users")

let FS_MESSAGE = Firestore.firestore().collection("message")

let REF_USERS = DB_REF.child("users")
let REF_USER_USERNAMES = DB_REF.child("user-usernames")

let REF_TWEETS = DB_REF.child("tweets")
let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")
let REF_USER_REPLIES = DB_REF.child("user-replies")
let REF_USER_TWEETS = DB_REF.child("user-tweets")

let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")

let REF_TWEET_LIKES = DB_REF.child("tweet-likes")
let REF_USER_LIKES = DB_REF.child("user-likes")

let REF_NOTIFICATION = DB_REF.child("notifications")
