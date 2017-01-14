//
//  SignUpViewController.swift
//  BallClub
//
//  Created by Joshua  Relova on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var createProfileButton: UIButton!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupUI(){
    self.navigationController?.navigationBar.isHidden = false
    var image = UIImage(named: "back")
    image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(SignUpViewController.backButtonPressed))
    
    
    createProfileButton.layer.borderColor = UIColor.white.cgColor
    createProfileButton.layer.borderWidth = 1
    emailTextField.attributedPlaceholder = NSAttributedString(string:"E-mail",
                                                              attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
    passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
    confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string:"Confirm Password",
                                                                        attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
  }
  
  func backButtonPressed(){
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SignUpToCreateProfileSgue" {
      if let createProfileVC: CreateProfileTableViewController = segue.destination as? CreateProfileTableViewController {
        if let email = emailTextField.text, let password = passwordTextField.text {
          createProfileVC.emailAddress =  email
          createProfileVC.password = password
        }
      }
    }
  }
  
  //MARK: - IBAction
  @IBAction func createProfileButtonPressed(_ sender: AnyObject) {
    if !Utilities.isValidEmail(email: emailTextField.text ?? "") {
      self.showAlert(title: "Error", message: "Invalid Email", callback: {})
    } else if let password = passwordTextField.text, let confirmPass = confirmPasswordTextField.text {
      if password.characters.count < 4 || confirmPass.characters.count < 4 {
        self.showAlert(title: "ERROR", message: "password should at least contain 4 characters", callback: {})
      } else if password != confirmPass {
        self.showAlert(title: "ERROR", message: "Password and confirm Password does not match", callback: {})
      } else {
        self.performSegue(withIdentifier: "SignUpToCreateProfileSgue", sender: self)
      }
    }else {
      self.showAlert(title: "Error", message: "Please input your password", callback: {})
    }
    
    
    
  }
  
}
