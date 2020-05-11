//
//  ProfileViewController.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 3/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UIViewControllerTransitioningDelegate{

    let transition = CircularTransition()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private var photosCollection = [newPost]() {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        updateUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
                updateUserInfo()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        updateUserInfo()
//    }
    
    private func updateUserInfo(){
        guard let user = Auth.auth().currentUser else {
                          return
                      }
                     // emailLabel.text = user.email
        if user.displayName == nil {
            displayName.text = "please input a display name"
            profileImage.image = UIImage(named: "still butterflies.gif")
        } else {
            displayName.text = user.displayName
                       profileImage.kf.setImage(with: user.photoURL)
        }
                  
    }
    
    private func configureView(){
        editProfile.layer.cornerRadius = editProfile.frame.size.width / 2
        collectionView.dataSource = self
        collectionView.delegate = self
    }
  
    
    
    @IBAction func signout(_ sender: UIButton) {
        // signout logic goes here
        do {
                 try Auth.auth().signOut()
            UIViewController.showViewController(storyboardName: "LoginView", viewControllerId: "LoginViewController")
              }catch{
                  DispatchQueue.main.async {
                      //self.showAlert(title: "Error siging out", message: "\(error.localizedDescription)")
                  }
                print("\(error)")
              }
    }
    
    private func fecthItems() {
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let updateVC = segue.destination as? UpdateProfileViewController
        updateVC?.transitioningDelegate = self
        updateVC?.modalPresentationStyle = .custom
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           transition.transitionMode = .present
           transition.startingPoint = editProfile.center
           transition.circleColor = editProfile.backgroundColor!
           return transition
       }
       
       func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           transition.transitionMode = .dismiss
           transition.startingPoint = editProfile.center
           transition.circleColor = editProfile.backgroundColor!
           
           return transition
       }
    

}

extension ProfileViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath)
               
               return cell
    }
    
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
  
    
    
    
}
