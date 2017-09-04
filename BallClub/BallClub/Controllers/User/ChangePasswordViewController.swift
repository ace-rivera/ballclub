//
//  ChangePasswordViewController.swift
//  BallClub
//
//  Created by Joshua Relova on 6/5/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
  @IBOutlet weak var oldPasswordTextField: UITextField!
  @IBOutlet weak var newPasswordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var submitButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var image = UIImage(named: "back")
    image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChangePasswordViewController.backButtonPressed))
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func backButtonPressed(){
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func didTapOnSubmitButton(_ sender: Any) {
  }
  
  
}
