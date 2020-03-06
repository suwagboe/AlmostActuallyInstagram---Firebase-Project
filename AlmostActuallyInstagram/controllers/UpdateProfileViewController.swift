//
//  UpdateProfileViewController.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 3/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController, UIViewControllerTransitioningDelegate {

    
    @IBOutlet weak var updateButton: UIButton!
    
    private let transition = CircularTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.layer.cornerRadius = updateButton.frame.size.width / 2
    }

    @IBAction func dismissSecondVC(_ sender: AnyObject) {
         
         self.dismiss(animated: true, completion: nil)
     
     }
    

}
