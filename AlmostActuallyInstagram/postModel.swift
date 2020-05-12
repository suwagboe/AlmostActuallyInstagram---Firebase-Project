//
//  postModel.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 5/5/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import Foundation
import FirebaseFirestore


struct newPost {
  let imageURL: String
  let caption: String
  let postedDate: Timestamp
  let userId: String
  let userDisplayImage: String
  let displayName: String
    
}


extension newPost {
   
    init(_ dictionary: [String: Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? "no imageURL "
        self.caption = dictionary["caption"] as? String ?? "there is no caption"
        self.postedDate = dictionary["postedDate"] as? Timestamp ?? Timestamp(date: Date())
        self.userId = dictionary["userId"] as? String ?? "no user ID "
        self.userDisplayImage = dictionary["userDisplayImage"] as? String ?? "no user Display Image"
        self.displayName = dictionary["displayName"] as? String ?? " no display Name"
    }
}
