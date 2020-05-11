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
    
    private var postIt: newPost?

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
        
        cell.layer.cornerRadius = 50
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 3
            let post = photoCollection[indexPath.row]
            cell.configureCell(for: post)
            cell.delegate = self
               return cell
    }
    
    
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let maxSize = UIScreen.main.bounds
    
  //  (self.objKeypadCollectionView.frame.size.width/3)-10, height: (self.objKeypadCollectionView.frame.size.height/4)-10)
  
    /*
    let width = (maxSize.width / 3) - 10
    let height = (maxSize.height / 4 ) - 10
    
            return CGSize(width: width , height: height)
 */
               //let maxSize = UIScreen.main.bounds
    return CGSize(width: maxSize.width * 0.7, height: maxSize.height * 0.50)

        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = photoCollection[indexPath.row]
                  
       postIt = post
        
        guard let dv = storyboard?.instantiateViewController(identifier: "DetailController") as? PhotoDetailController else {
                fatalError("could not access detailcontroller")
            }
                     dv.post = postIt
        navigationController?.pushViewController(dv, animated: true)
    }
}


extension PhotoCollectionViewController: PostCellDelegate{
    func didSelectSellerName(_ postCell: PostCell, item: newPost) {
        ///
    }
    
    
}
