//
//  PostCell.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 5/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import Kingfisher
//import FirebaseAuth
import Firebase


protocol PostCellDelegate: AnyObject{
    func didSelectSellerName(_ postCell: PostCell, item: newPost)
}

class PostCell: UICollectionViewCell {

    
    // step  2 custom protocol
    weak var delegate: PostCellDelegate?

        @IBOutlet weak var itemImageView: UIImageView!
        @IBOutlet weak var itemNameLabel: UILabel!
        @IBOutlet weak var sellerNameLabel: UILabel!
        @IBOutlet weak var dateLabel: UILabel!
       // @IBOutlet weak var priceLabel: UILabel!
    
    // when clicked it should segue to the other view controller.
    private var currentItem: newPost!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
       let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(handleTap(_:)))
        
        return gesture
    }()
        
    override func layoutSubviews() {
        super.layoutSubviews()
        sellerNameLabel.textColor = .systemPink
        sellerNameLabel.addGestureRecognizer(tapGesture)
        sellerNameLabel.isUserInteractionEnabled = true
    }
        
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        // step 3 custom delegate
        delegate?.didSelectSellerName(self, item: currentItem)
      //  print("\(currentItem) was tapped")
    }
    
        public func configureCell(for post: newPost){
            currentItem = post
            updateUI(imageURL: post.imageURL, sellerName: post.userID,
                     //date: post.postedDate,
                 caption: post.caption)
        }
    
        
    
    private func updateUI(imageURL: String,
                          sellerName: String,
                         // date: Timestamp,
                          caption: String ) {
        // todo: set up image, import kingfisher, install kingfisher via pods
                   itemImageView.kf.setImage(with: URL(string: imageURL))

                  // itemNameLabel.text = itemName
                   sellerNameLabel.text = "@\(sellerName)"
                 //  dateLabel.text = date.dateValue().dateStrin() // from the extension that we made.
                 //  priceLabel.text = "$\(price)"
                   
    }
    }

