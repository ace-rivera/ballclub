//
//  CreateProfileTableViewController.swift
//  BallClub
//
//  Created by Joshua Relova on 8/31/16.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import MaterialKit

class CreateProfileTableViewController: UITableViewController {
  
  @IBOutlet weak var aboutMeTextField: MKTextField!
  @IBOutlet weak var favoriteTeamTextField: MKTextField!
  @IBOutlet weak var favoritePlayerTextField: MKTextField!
  @IBOutlet weak var sexTextField: MKTextField!
  @IBOutlet weak var weightTextField: MKTextField!
  @IBOutlet weak var birthDateTextField: MKTextField!
  @IBOutlet weak var heightTextField: MKTextField!
  @IBOutlet weak var homeCityTextField: MKTextField!
  @IBOutlet weak var lastNameTextField: MKTextField!
  @IBOutlet weak var firstNameTextField: MKTextField!
  @IBOutlet weak var centerButton: UIButton!
  @IBOutlet weak var forwardButton: UIButton!
  @IBOutlet weak var guardButton: UIButton!
  @IBOutlet weak var userProfileImage: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  override func viewWillAppear(animated: Bool) {
    setupUi()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func setupUi(){
    guardButton.selected = true
    forwardButton.selected = false
    centerButton.selected = false
    userProfileImage.layer.borderColor = UIColor.whiteColor().CGColor
    
    firstNameTextField.layer.borderColor = UIColor.clearColor().CGColor
    lastNameTextField.layer.borderColor = UIColor.clearColor().CGColor
    homeCityTextField.layer.borderColor = UIColor.clearColor().CGColor
    heightTextField.layer.borderColor = UIColor.clearColor().CGColor
    weightTextField.layer.borderColor = UIColor.clearColor().CGColor
    birthDateTextField.layer.borderColor = UIColor.clearColor().CGColor
    sexTextField.layer.borderColor = UIColor.clearColor().CGColor
    favoritePlayerTextField.layer.borderColor = UIColor.clearColor().CGColor
    favoriteTeamTextField.layer.borderColor = UIColor.clearColor().CGColor
    aboutMeTextField.layer.borderColor = UIColor.clearColor().CGColor
    
    self.navigationController?.navigationBar.hidden = false
    var image = UIImage(named: "back")
    image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateProfileTableViewController.backButtonPressed))
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateProfileTableViewController.registerUser))
    self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    
    
    
  }
  
  @IBAction func positionButtonPressed(sender: UIButton) {
    switch sender.tag {
    case 0:
      guardButton.selected = true
      forwardButton.selected = false
      centerButton.selected = false
    case 1:
      guardButton.selected = false
      forwardButton.selected = true
      centerButton.selected = false
    case 2:
      guardButton.selected = false
      forwardButton.selected = false
      centerButton.selected = true
    default:
      break
    }
  }
  
  func backButtonPressed(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func registerUser() {
    //register user and push to main screen
    pushToMainStoryboard()
  }
  
  func pushToMainStoryboard(){
    self.performSegueWithIdentifier("LoginToMainSegue", sender: self)
  }
}
