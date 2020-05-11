//
//  PhotoDetailController.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 5/11/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

class PhotoDetailController: UIViewController {
    
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    // selected photo instance
    var post: newPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI(){
        guard let post = post else {
            print("could not properly access the photo")
            return
        }
        
        userLabel.text = "@\(post.displayName)"
        dateLabel.text = "posted: \(post.postedDate)"
        captionLabel.text = """
                                CAPTION:
                                    \(post.caption)
        """
        
        photo.kf.setImage(with: URL(string: post.imageURL))
    }

}
