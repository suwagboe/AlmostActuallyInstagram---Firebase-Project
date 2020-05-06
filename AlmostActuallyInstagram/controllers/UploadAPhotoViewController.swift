//
//  UploadAPhotoViewController.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 3/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

class UploadAPhotoViewController: UIViewController {
    
    
    @IBOutlet weak var butterflyImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    private lazy var imagePickerController: UIImagePickerController = {
       let picker = UIImagePickerController()
     //   picker.delegate = self
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
        guard let seletedImage = butterflyImage.image else {
            print("the image they selected is not avaiable")
            return
        }
        guard let caption = textField.text else {
           print("they in things but they are not avaible from the text field ")
            return
        }
        var createdPost = newPost(image: seletedImage, description: caption)
        
        // want to gain access to firebase data to gain push this create post
        
    }
    
    


}

extension UploadAPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("couldnt attain original image")
        }
    selectedImage = image
        // want it to dismiss once its finished
        dismiss(animated: true)
    }
}

extension UploadAPhotoViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            //showAlert(title: "Youre not done yet", message: "Hey.. sorry to say it but you need to type something into the description or else how will we know.. ")
            print("they haven't filled out the caption")
        } else {
            guard let text = textField.text else {
                return false
            }
           // editingText = text
           // print(editingText)
        }
        
        
        textField.resignFirstResponder()
        return true
    }
}
