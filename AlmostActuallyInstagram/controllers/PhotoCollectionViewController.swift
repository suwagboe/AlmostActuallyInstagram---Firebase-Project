//
//  PhotoCollectionViewController.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 3/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class PhotoCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let databaseService = DatabaseServices()
    
    private var listener: ListenerRegistration?

    private var photoCollection = [newPost]() {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
            listener = Firestore.firestore().collection(DatabaseServices.postCollection)
            .addSnapshotListener({[weak self ](snapshot, error) in
                if let error = error {
                    DispatchQueue.main.async {
                      //  self?.showAlert(title: "Firestore Error", message: "\(error.localizedDescription)")
                        print(error.localizedDescription)
                    }
                } else if let snapshot = snapshot {
                    print("there are \(snapshot.documents.count) items for sell")
                    let posts = snapshot.documents.map {newPost($0.data()) }
                    // maps for thru each element in the array
                    // each element represents $0
                    //$0.data is a dictonary
                    // for item in item is item and that is $0.data
                    self?.photoCollection = posts
                }
            })
        }
    
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillAppear(true)
            listener?.remove() // no longer are we listening for changes from Firebase
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView(){
          collectionView.dataSource = self
          collectionView.delegate = self
      }
    
}

extension PhotoCollectionViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? PostCell else {
            fatalError("cant downcast as cell ")
        }
            let post = photoCollection[indexPath.row]
            cell.configureCell(for: post)
            cell.delegate = self
               return cell
    }
    
    
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = photoCollection[indexPath.row]
                  
                  // need to access the other storyboard to inject it into it
//                  let storyboard = UIStoryboard(name: "MainView", bundle: nil)
//                  let detailVC = storyboard.instantiateViewController(identifier: "ItemDetailController") { (coder) in
                    //  return ItemDetailController(coder: coder, item: item)
                      
                //  }
                  // notice if this controller is not embedded in a navController then it will not show the next controller even if the next controller that are seguing to is already embedded in a nav controller
                  
                  // all you need to do is embedd it.
                //  navigationController?.pushViewController(detailVC, animated: true)

    }
}


extension PhotoCollectionViewController: PostCellDelegate{
    func didSelectSellerName(_ postCell: PostCell, item: newPost) {
        ///
    }
    
    
}
