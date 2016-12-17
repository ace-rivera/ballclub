//
//  LoginViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var forgotDetailsButton: UIButton!
  @IBOutlet weak var loginButton: FBSDKLoginButton!
  @IBOutlet weak var passwordLabel: UITextField!
  @IBOutlet weak var emailAddLabel: UITextField!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var appLogo: UIImageView!
  
  var playerViewModel = PlayerViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupUI()
  }
  
  func setupUI() {
    self.navigationController?.navigationBar.isHidden = true
    loginButton.layer.borderColor = UIColor.lightGray.cgColor
    loginButton.layer.borderWidth = 1
    
    emailAddLabel.attributedPlaceholder = NSAttributedString(string:"E-mail",
                                                             attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
    passwordLabel.attributedPlaceholder = NSAttributedString(string:"Password",
                                                             attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - IBAction
  @IBAction func loginButtonPressed(_ sender: AnyObject) {
    if let email = emailAddLabel.text, let password = passwordLabel.text {
      playerViewModel.playerSign(emailAddress: email, password: password) { (success, message) -> (Void) in
        if success == true {
          self.performSegue(withIdentifier: "LoginToMainSegue", sender: self)
        } else {
          if let m = message {
            self.showAlert(title: "ERROR", message: m, callback: {})
          }
        }
      }
    }
  }
  
  @IBAction func loginWithFacebookButtonPressed(_ sender: AnyObject) {
    let login = FBSDKLoginManager()
    login.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
      if ((error) != nil)  {
      //  NSLog("Facebook Process error: %@", error);
      }
      else if (result?.isCancelled)!
      {
        NSLog("Facebook Cancelled");
      }
      else {
        self.getFacebookUserInfo()
      }
    }
  }
  
  func getFacebookUserInfo(){
    if ((FBSDKAccessToken.current()) != nil) {
      FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.width(300).height(300)"]).start { (connection, result, error) in
        if error == nil {
          //print("Facebook Fetched user : \(result)")
          
          //TODO: Save user details
          
          //profile picture
//          var user : AnyObject!
//          user = result["id"]
//          let fbURL = NSURL(string: "http://graph.facebook.com/\(user)/picture?type=large")
//          if let data = NSData(contentsOfURL: fbURL! as URL) {
//            let userProfilePic = UIImage(data: data)
//          }
//          print("First Name : \(result["first_name"])") //remove optional
//          print("Last Name : \(result["last_name"])")
//          print("Gender : \(result["gender"])")
          
        self.performSegue(withIdentifier: "LoginToMainSegue", sender: self)
        }
      }
    }
  }
  
  @IBAction func signUpHereButtonPressed(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "LoginToSignUpSegue", sender: self)
  }
  
}
