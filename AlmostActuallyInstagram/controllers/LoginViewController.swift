//
//  LoginViewController.swift
//  AlmostActuallyInstagram
//
//  Created by Pursuit on 3/6/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {
    
      @IBOutlet weak var errorLabel: UILabel!
      @IBOutlet weak var containerView: UIView!
      @IBOutlet weak var emailTextField: UITextField!
      @IBOutlet weak var passwordTextField: UITextField!
      @IBOutlet weak var loginButton: UIButton!
      @IBOutlet weak var accountStateMessageLabel: UILabel!
      @IBOutlet weak var accountStateButton: UIButton!
      
      private var accountState: AccountState = .existingUser
      
      private var authSession = AuthenticationSession()
      
      override func viewDidLoad() {
          super.viewDidLoad()
          clearErrorLabel()
      }
      
      @IBAction func loginButtonPressed(_ sender: UIButton) {
          print("login button pressed")
          
          guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
              print("missing info")
              return
          }
          continueLoginFlow(email: email, password: password)
      }
      
      private func continueLoginFlow(email: String, password: String) {
          if accountState == .existingUser {
              authSession.signExistingUser(email: email, password: password) { [weak self] (result) in
                  switch result {
                  case .failure(let error):
                      DispatchQueue.main.async {
                          self?.errorLabel.text = "\(error.localizedDescription)"
                          self?.errorLabel.textColor = .red
                      }
                  case .success:
                      DispatchQueue.main.async {
                          self?.navigateToMainView()
                          
                      }
                  }
              }
          } else {
              authSession.createNewUser(email: email, password: password) { [weak self] (result) in
                  
                  switch result {
                  case .failure(let error):
                      DispatchQueue.main.async {
                          self?.errorLabel.text = "\(error.localizedDescription)"
                          self?.errorLabel.textColor = .red
                      }
                  case .success:
                      DispatchQueue.main.async {
                          self?.navigateToMainView()
                          
                      }
                  }
              }
          }
      }
      
      private func navigateToMainView() {
          UIViewController.showViewController(storyboardName: "MainView", viewControllerId: "MainTabBarController")
        //print("should go to main view")
      }
      
      private func clearErrorLabel() {
          errorLabel.text = ""
      }
      
      @IBAction func toggleAccountState(_ sender: UIButton) {
          // change the account login state
          accountState = accountState == .existingUser ? .newUser : .existingUser
          
          // animation duration
          let duration: TimeInterval = 1.0
          
          if accountState == .existingUser {
             // UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
                  self.loginButton.setTitle("Login", for: .normal)
                  self.accountStateMessageLabel.text = "Don't have an account ? Click"
                  self.accountStateButton.setTitle("SIGNUP", for: .normal)
             // }, completion: nil)
          } else {
              //UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
                  self.loginButton.setTitle("Sign Up", for: .normal)
                  self.accountStateMessageLabel.text = "Already have an account ?"
                  self.accountStateButton.setTitle("LOGIN", for: .normal)
              //}, completion: nil)
          }
      }


}
