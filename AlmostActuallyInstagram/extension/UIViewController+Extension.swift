//
//  UIViewController+Extension.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 3/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    public static func resetWindow(_ rootViewController: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first, let sceneDelegate = scene.delegate as? SceneDelegate, let window = sceneDelegate.window else {
            fatalError("could not reset window rootViewController")
        }
        
        window.rootViewController = rootViewController
    }
    
    public static func showViewController(storyboardName: String, viewControllerId: String) {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        let newVC = storyboard.instantiateViewController(identifier: viewControllerId)
        
        resetWindow(newVC)
    }
    
}
