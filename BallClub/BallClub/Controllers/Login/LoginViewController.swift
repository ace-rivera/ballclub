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
  @IBOutlet weak var fbLoginButton: UIButton!
  
  
  var registrationViewModel = RegistrationViewModel()
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
    
    fbLoginButton.isHidden = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - IBAction
  @IBAction func loginButtonPressed(_ sender: AnyObject) {
    Utilities.showProgressHud(withTitle: "Logging In", inView: self.view)
    if let email = emailAddLabel.text, let password = passwordLabel.text {
      registrationViewModel.playerSign(emailAddress: email, password: password) { (responseCode, message, accessToken, client, userId) -> (Void) in
        if responseCode == 400 || responseCode == 401 {
          Utilities.hideProgressHud()
          if let m = message {
            self.showAlert(title: "ERROR", message: m, callback: {})
          }
        } else {
          self.registrationViewModel.getToken(clientId: Constants.clientId, clientSecret: Constants.clientSecret, grantType: Constants.grantType, completionBlock: { (responseCode, message, token) -> (Void) in
            Utilities.hideProgressHud()
            if (responseCode == 200 || responseCode == 201), let t = token, let accessToken = accessToken, let client = client, let id = userId {
              UserDefaults.standard.set(t, forKey: "Token")
              SessionManager.sharedInstance.saveSession(username: email, token: t, accessToken: accessToken, client: client)
              UserDefaults.standard.set(email, forKey: "UserEmailAddress")
              self.getCurrentUser(userId: id)
            } else {
              if let m = message {
                self.showAlert(title: "Error", message: m, callback: {})
              }
            }
          })
          
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
  
  func getCurrentUser(userId: Int) {
    self.playerViewModel.getUser(userId: userId, completionBlock: { (statusCode, message, player) -> (Void) in
      if (statusCode == 200 || statusCode == 201), let p = player {
        var test = Player.toDictionary(user: p)
        UserDefaults.standard.set(Player.toDictionary(user: p), forKey: "currentUser")
        self.emailAddLabel.text = ""
        self.passwordLabel.text = ""
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.didLoginNotification), object: nil)
      } else {
        self.showAlert(title: "ERROT", message: message, callback: {})
      }
    })
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
