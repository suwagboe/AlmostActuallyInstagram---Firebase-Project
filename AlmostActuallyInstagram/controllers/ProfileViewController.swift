//
//  ProfileViewController.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 3/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIViewControllerTransitioningDelegate{

    let transition = CircularTransition()
    
    @IBOutlet weak var editProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfile.layer.cornerRadius = editProfile.frame.size.width / 2
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
