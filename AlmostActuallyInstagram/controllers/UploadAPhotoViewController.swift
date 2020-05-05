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
    @IBOutlet weak var imageDescription: UITextField!
    
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

    }
    
    @objc private func showPhotoOptions() {
        let alertController = UIAlertController(title: "Where is the photo", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "capture the moment live", style: .default) { (action) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        
        let photoLibrary = UIAlertAction(title: "look at your photos", style: .default) { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "", style: .cancel)
          
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alertController.addAction(cameraAction)
        }
        
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
       }

    
    


}
