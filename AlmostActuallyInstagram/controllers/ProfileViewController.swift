//
//  ProfileViewController.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 3/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController, UIViewControllerTransitioningDelegate{

    let transition = CircularTransition()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listener: ListenerRegistration?
    
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
       // updateUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
     //   updateUserInfo()
        guard let user = Auth.auth().currentUser else {
                return
            }
        
        
        listener = Firestore.firestore().collection(DatabaseServices.postCollection)
              .addSnapshotListener({[weak self ](snapshot, error) in
                  if let error = error {
                      DispatchQueue.main.async {
                          self?.showAlert(title: "Firestore Error", message: "\(error.localizedDescription)")
                      }
                  } else if let snapshot = snapshot {
                      print("there are \(snapshot.documents.count) items for sell")
                      let posts = snapshot.documents.map {newPost($0.data()) }
                    
                    // MARK: Alex why is this not working
                    self?.photosCollection = posts.filter { $0.userId == user.uid }
                    
                  }
              })
    }

    private func updateUserInfo(){
        guard let user = Auth.auth().currentUser else {
                          return
                      }
        if user.displayName == nil {
            displayName.text = "please input a display name"
            profileImage.image = UIImage(named: "still butterflies.gif")
        } else {
            displayName.text = user.displayName
            //profileImage.image = UIImage(named: "still butterflies.gif")
            profileImage.kf.setImage(with: URL(string: "https://www.humanesociety.org/sites/default/files/styles/768x326/public/2018/08/kitten-440379.jpg"))
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
                      self.showAlert(title: "Error siging out", message: "\(error.localizedDescription)")
                  }
                print("\(error)")
              }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let updateVC = segue.destination as? UpdateProfileViewController
        updateVC?.transitioningDelegate = self
        updateVC?.modalPresentationStyle = .custom
      //  updateUserInfo()
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
        return photosCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as? PostCell else {
            fatalError("could not access the PostCell ")
        }

        cell.layer.cornerRadius = 50
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 3
        let post = photosCollection[indexPath.row]
        cell.configureCell(for: post)
               return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               //let maxSize = UIScreen.main.bounds
       
     //  (self.objKeypadCollectionView.frame.size.width/3)-10, height: (self.objKeypadCollectionView.frame.size.height/4)-10)
     
       /*
       let width = (maxSize.width / 3) - 10
       let height = (maxSize.height / 4 ) - 10
       
               return CGSize(width: width , height: height)
    */
                  //let maxSize = UIScreen.main.bounds
   let interItemSpacing: CGFloat = 10
              let maxWidth = UIScreen.main.bounds.size.width
              
              let numberOfItems: CGFloat = 2
              let totalSpacing: CGFloat = numberOfItems - interItemSpacing
              
              let itemWidth: CGFloat = (maxWidth - totalSpacing)/numberOfItems
              
              return CGSize(width: itemWidth, height: itemWidth)
          }
          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
              
              return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
          }
          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
              
              return 5
          }
    
    
}

