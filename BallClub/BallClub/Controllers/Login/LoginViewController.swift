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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    setupUI()
  }
  
  func setupUI() {
    self.navigationController?.navigationBar.hidden = true
    loginButton.layer.borderColor = UIColor.lightGrayColor().CGColor
    loginButton.layer.borderWidth = 1
    
    emailAddLabel.attributedPlaceholder = NSAttributedString(string:"E-mail",
                                                             attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    passwordLabel.attributedPlaceholder = NSAttributedString(string:"Password",
                                                             attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - IBAction
  @IBAction func loginButtonPressed(sender: AnyObject) {
    self.performSegueWithIdentifier("LoginToMainSegue", sender: self)
  }
  
  @IBAction func loginWithFacebookButtonPressed(sender: AnyObject) {

    let login = FBSDKLoginManager()
    login.logInWithReadPermissions(["public_profile","email"], fromViewController: self) { (result, error) in
      if ((error) != nil)  {
        NSLog("Facebook Process error: %@", error);
      }
      else if (result.isCancelled)
      {
        NSLog("Facebook Cancelled");
      }
      else {
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
          FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, gender"]).startWithCompletionHandler { (connection, result, error) in
            if error == nil {
              print("Facebook Fetched user : \(result)")
              //TODO: Save user details
              self.performSegueWithIdentifier("LoginToMainSegue", sender: self)
            }
          }
        }
      }
    }
  }
  
  @IBAction func signUpHereButtonPressed(sender: AnyObject) {
    self.performSegueWithIdentifier("LoginToSignUpSegue", sender: self)
  }
  
}
