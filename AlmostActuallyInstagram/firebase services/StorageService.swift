//
//  StorageService.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 5/5/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import Foundation
import FirebaseStorage



class StorageService {
  
    private let storageRef = Storage.storage().reference()
    
 
    public func uploadPhoto(userID: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> ()){
   
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }

        var photoReference: StorageReference!
        
      if let userID = userID {
            photoReference = storageRef.child("UserProfilePhotos/\(userID).jpg")
        } 
    
        let metadata = StorageMetadata() // instance from firebase
        metadata.contentType = "image/jpg" // MIME type
 
        let _ = photoReference.putData(imageData, metadata: metadata) {
            (metadata, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let _ = metadata {
                photoReference.downloadURL { (url, error) in
                    if let error = error{
                        completion(.failure(error))
                    } else if let url = url {
                   
                        completion(.success(url))
                    }
                    
                }
            }
        }
        
    }// end of func
    
}// end of class
