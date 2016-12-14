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
  @IBOutlet weak var passwordTextField: MKTextField!
  @IBOutlet weak var confirmPasswordTextField: MKTextField!
  @IBOutlet weak var emailTextField: MKTextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    // Do any additional setup after loading the view.
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
    
    
    createProfileButton.layer.borderColor = UIColor.lightGray.cgColor
    createProfileButton.layer.borderWidth = 1
    
    emailTextField.attributedPlaceholder = NSAttributedString(string:"E-mail",
                                                              attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string:"Confirm Password",
                                                                        attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    
    
    emailTextField.layer.borderColor = UIColor.clearColor().CGColor
    passwordTextField.layer.borderColor = UIColor.clearColor().CGColor
    confirmPasswordTextField.layer.borderColor = UIColor.clearColor().CGColor
    
    
    
  }
  
  func backButtonPressed(){
    self.navigationController?.popViewController(animated: true)
    
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  //MARK: - IBAction
  @IBAction func createProfileButtonPressed(sender: AnyObject) {
    self.performSegue(withIdentifier: "SignUpToCreateProfileSgue", sender: self)
  }
  
}
