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
                                                              attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
    passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
    confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string:"Confirm Password",
                                                                        attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
    
    
    emailTextField.layer.borderColor = UIColor.clear.cgColor
    passwordTextField.layer.borderColor = UIColor.clear.cgColor
    confirmPasswordTextField.layer.borderColor = UIColor.clear.cgColor
    
    
    
  }
  
  func backButtonPressed(){
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  //MARK: - IBAction
  @IBAction func createProfileButtonPressed(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "SignUpToCreateProfileSgue", sender: self)
  }
  
}
