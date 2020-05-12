//
//  UploadAPhotoViewController.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 3/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UploadAPhotoViewController: UIViewController {
    
    
    @IBOutlet weak var butterflyImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    private let dbService = DatabaseServices()
    private let storageService = StorageService()

    
    private lazy var imagePickerController: UIImagePickerController = {
       let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(showPhotoOptions))
        return gesture
    }()

    private var selectedImage: UIImage? {
        didSet {
            butterflyImage.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView(){
        butterflyImage.isUserInteractionEnabled = true
        butterflyImage.addGestureRecognizer(longPressGesture)
        textField.delegate = self
    }
    
    @objc private func showPhotoOptions() {
        let alertController = UIAlertController(title: "please choose a moment", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "capture the moment live", style: .default) { (action) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        
        let photoLibrary = UIAlertAction(title: "look at your photos", style: .default) { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
          
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
       }
    
   
    
    @IBAction func Post(_ sender: UIButton) {
        // they cant post something until they have a display name so it will prompt them
// Auth.auth() user is different
        guard let displayName = Auth.auth().currentUser?.displayName else {
            DispatchQueue.main.async {
                self.showAlert(title: "Incomplete Profile", message: "Please complete your profile")
            }
  
               return
               }

        guard let seletedImage = butterflyImage.image else {
            print("the image they selected is not avaiable")
            return
        }
        guard let caption = textField.text, !caption.isEmpty else {
           print("they in things but they are not avaible from the text field ")
            return
        }
            let resizedImage = UIImage.resizeImage(originalImage: seletedImage, rect: butterflyImage.bounds)
        
        dbService.createAPost(displayName: displayName, caption: caption, completion:   { [weak self]
                  (result) in
                  switch result {
                  case .failure(let error):
                      print(error)
                  case .success(let docId):
                      self?.uploadPhoto(photo: resizedImage, documentId: docId)
                  }
              })
        dismiss(animated: true)

    }
    
    private func uploadPhoto(photo: UIImage, documentId: String){
        storageService.uploadPhoto(userID: documentId, image: photo) {
            (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
            case .success(let url):
                // when the item is CREATED we do not have access to the url yet
                self.updatePostURL(url, documentId: documentId)
            }
        }
    }
    
    private func updatePostURL(_ url: URL, documentId: String){
        // update an exisiting doc on firebase
        Firestore.firestore().collection(DatabaseServices.postCollection).document(documentId).updateData(["imageURL": url.absoluteString]) { [weak self]
            (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "failed to update item", message: "\(error.localizedDescription)")
                   // print(error.localizedDescription)
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
                print("all went well with the update")
            }
        }
    }
} // end of class

extension UploadAPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("couldnt attain original image")
        }
    selectedImage = image
        dismiss(animated: true)
    }
}

extension UploadAPhotoViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            DispatchQueue.main.async {
                self.showAlert(title: "Youre not done yet", message: "Hey.. sorry to say it but you need to type something into the description or else how will we know.. ")
                
            }
                   } else {
          //  guard let text = textField.text else {
            //    return false
           // }
           // editingText = text
           // print(editingText)
        }
        
        
        textField.resignFirstResponder()
        return true
    }
}
