//
//  UpdateProfileViewController.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 3/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class UpdateProfileViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    private let storageService = StorageService()
    private let databaseService = DatabaseServices()
    private let transition = CircularTransition()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    private var convertImageViewToImage: UIImage? {
        didSet{
            self.profileImage.image = self.convertImageViewToImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.layer.cornerRadius = updateButton.frame.size.width / 2
        textField.delegate = self
        configureUI()
    }
    
    
    private func configureUI(){
                guard let user = Auth.auth().currentUser else {
            return
        }
        emailLabel.text = user.email
        textField.text = user.displayName
        profileImage.kf.setImage(with: user.photoURL)
        
    }
    
    @IBAction func dismissSecondVC(_ sender: AnyObject) {
        gatherUpdateInfo()
    }
    
    
    @IBAction func addPhotoButton(_ sender: UIButton) {
        
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
    
    
    private func gatherUpdateInfo(){
        guard let displayName = textField.text, !displayName.isEmpty, let seletedImage = convertImageViewToImage else {
            print("missing fields cannot be found please try again")
            return
        }
        
        guard let user = Auth.auth().currentUser else { return }
        
        let resizedImage = UIImage.resizeImage(originalImage: seletedImage, rect: profileImage.bounds)
        
        updateStorageService(user: user, image: resizedImage, displayName: displayName)
        
    }
    
    private func updateStorageService(user: User, image: UIImage, displayName: String){
        storageService.uploadPhoto(userID: user.uid, image: image) {  [weak self]
            (result) in
            switch result{
            case .failure(let error):
                                DispatchQueue.main.async {
                                    self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                                }
               // print("this is wrong inside of storage service b/c \(error.localizedDescription)")
            case .success(let url):
                self?.updateDatabaseUser(displayName: displayName, photoURL: url.absoluteString)
                print("the request went through and the displayName and url have been updated")
                
            }
        }
        
    }
    private func updateDatabaseUser(displayName: String, photoURL: String) {
        print("inside updateDatabaseUser")
        
        databaseService.updateDatabaseUser(displayName: displayName, photoURL: photoURL) {
            
            (result) in
            switch result {
            case .failure(let error):
                print("failed to update db user: \(error)")
            case .success:
                self.request(displayName: displayName, url: URL(fileURLWithPath: photoURL))
                print("successfully updated db user")
            }
        }
    }
    
    private func request(displayName: String, url: URL){
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.displayName = displayName
        request?.photoURL = url
        // this saves the changes??
        request?.commitChanges(completion: { [unowned self] (error) in
            // unowned self, because it will only exsit when this controller exists...
            if let error = error {
                //MARK: Show alert
                DispatchQueue.main.async {
                      self.showAlert(title: "Error updating profile", message: "Error changing Profile: \(error.localizedDescription)")
                }
               // print("commitChange error: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                      self.showAlert(title: "Profile Updated ", message: "Your Profile has been updated successfully")
                    // dismiss the controller here
                }
                
                
                self.dismiss(animated: true, completion: nil)

               // print("profile successfully updated ")
            }
        })
    }
}

extension UpdateProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UpdateProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("couldnt attain original image")
        }
        convertImageViewToImage = image
        // want it to dismiss once its finished
        dismiss(animated: true)
    }
}
