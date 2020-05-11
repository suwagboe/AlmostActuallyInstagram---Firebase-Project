//
//  DataBaseServices.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 5/5/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseServices{
    
    static let userCollection = "users"

    static let postCollection = "postCollection"
    
    private let db = Firestore.firestore()
    
    public func createAPost(displayName: String, caption: String,  completion: @escaping (Result <String, Error>) -> ()) {
           guard let user = Auth.auth().currentUser else { return }
        let documentRef = db.collection(DatabaseServices.postCollection).document()
          
        db.collection(DatabaseServices.postCollection).document(documentRef.documentID).setData([
            "caption": caption,
            "postedDate" :Timestamp(date: Date()),
            "userId" : user.uid,
          //  "userDisplayImage": userDisplayImage,
            "displayName": displayName,
        ]) { (error) in
            if let error = error {
                print("error creating item: \(error)")
                completion(.failure(error))
            } else {
                completion(.success(documentRef.documentID))
            }
        }
       }
    
//    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>) -> ()) {
//          guard let email = authDataResult.user.email else {
//              return
//          }
//          // What is this line of code doing ???
//        db.collection(DatabaseServices.postCollection).document(authDataResult.user.uid).setData(["email" : email, "createdData": Timestamp(date: Date()), "userId": authDataResult.user.uid]) { (error) in
//              
//              if let error = error {
//                  completion(.failure(error))
//              } else {
//                  completion(.success(true))
//              }
//              
//          }
//      }
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>) -> ()) {
               guard let email = authDataResult.user.email else {
                   return
               }
             db.collection(DatabaseServices.userCollection).document(authDataResult.user.uid).setData(["email" : email, "createdData": Timestamp(date: Date()), "userId": authDataResult.user.uid]) { (error) in
                   
                   if let error = error {
                       completion(.failure(error))
                   } else {
                       completion(.success(true))
                   }
                   
               }
           }
    func updateDatabaseUser(displayName: String, photoURL: String, completion: @escaping (Result<Bool, Error>) -> ()) {
             guard let user = Auth.auth().currentUser else { return }
             db.collection(DatabaseServices.userCollection).document(user.uid).updateData(["photoURL" : photoURL, "displayName": displayName]) { (error) in
                 if let error = error {
                     completion(.failure(error))
                 } else {
                    print("inside of the database the update user was successful")
                     completion(.success(true))
                 }
             }
         }
    
    
    public func fetchUserPosts(userId: String, completion: @escaping (Result<[newPost], Error>) -> ()){
          
          db.collection(DatabaseServices.postCollection).whereField("userId", isEqualTo: userId).getDocuments {  (snapshot, error) in
              if let error = error {
                  completion(.failure(error))
              } else if let snapshot = snapshot {
                  let items = snapshot.documents.map { newPost($0.data()) }
                 
                  completion(.success(items.sorted(by: { $0.postedDate.seconds > $1.postedDate.seconds
                  })))
              }
              }
          }
    
}
