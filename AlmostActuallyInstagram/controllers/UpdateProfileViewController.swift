//
//  UpdateProfileViewController.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 3/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var updateButton: UIButton!
    
    private let transition = CircularTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.layer.cornerRadius = updateButton.frame.size.width / 2
        updateUI()
    }
    
    private func updateUI(){
           // guard let user = Auth.auth().currentUser else {
//                       return
//                   }
//                   emailLabel.text = user.email
//                   displayNameTextField.text = user.displayName
//            profilleImageView.kf.setImage(with: user.photoURL)
                    //user.phoneNumber
                   // user.photoURL
        }

    @IBAction func dismissSecondVC(_ sender: AnyObject) {
         
         self.dismiss(animated: true, completion: nil)
     
     }
    
}


extension UploadAPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ":", for: indexPath)
        
        return cell
    }
    
    
    
}

extension UploadAPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize = UIScreen.main.bounds
         let spacingBetweenItems: CGFloat = 11
              let numberOfItems: CGFloat = 3
              let totalSpacing: CGFloat = (2 * spacingBetweenItems) + (numberOfItems - 1) * spacingBetweenItems
              let itemWidth: CGFloat = (maxSize.width - totalSpacing) / numberOfItems
              let itemHeight: CGFloat = maxSize.height * 0.20
              return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      }
      
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          // segue to CreateItemViewController.
       //   let catergory = categoires[indexPath.row]
          let mainViewStoryboard = UIStoryboard(name: "MainView", bundle: nil)
         // let createInstance = mainViewStoryboard.instantiateViewController(identifier: "CreateItemViewController") {
            //  coder in
           //   return CreateViewController()
       //   }
      
         // present(UINavigationController(rootViewController:createInstance), animated: true)
      }
    
    
}

