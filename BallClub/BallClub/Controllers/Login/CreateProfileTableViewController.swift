//
//  CreateProfileTableViewController.swift
//  BallClub
//
//  Created by Joshua Relova on 8/31/16.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class CreateProfileTableViewController: UITableViewController {
  
  @IBOutlet weak var aboutMeTextField: UITextField!
  @IBOutlet weak var favoriteTeamTextField: UITextField!
  @IBOutlet weak var favoritePlayerTextField: UITextField!
  @IBOutlet weak var sexTextField: UITextField!
  @IBOutlet weak var weightTextField: UITextField!
  @IBOutlet weak var birthDateTextField: UITextField!
  @IBOutlet weak var heightTextField: UITextField!
  @IBOutlet weak var homeCityTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var centerButton: UIButton!
  @IBOutlet weak var forwardButton: UIButton!
  @IBOutlet weak var guardButton: UIButton!
  @IBOutlet weak var userProfileImage: UIImageView!
  
  
  var imagePicker :  UIImagePickerController!
  var emailAddress = ""
  var password = ""
  let registrationViewModel = RegistrationViewModel()
  let playerViewModel = PlayerViewModel()
  
  //MARK:- Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    
    
    setupUi()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  //MARK:- SetupUI
  func setupUi(){
    guardButton.isSelected = true
    forwardButton.isSelected = false
    centerButton.isSelected = false
    userProfileImage.layer.borderColor = UIColor.white.cgColor
    userProfileImage.isUserInteractionEnabled = true
    
    firstNameTextField.layer.borderColor = UIColor.clear.cgColor
    lastNameTextField.layer.borderColor = UIColor.clear.cgColor
    homeCityTextField.layer.borderColor = UIColor.clear.cgColor
    heightTextField.layer.borderColor = UIColor.clear.cgColor
    weightTextField.layer.borderColor = UIColor.clear.cgColor
    birthDateTextField.layer.borderColor = UIColor.clear.cgColor
    sexTextField.layer.borderColor = UIColor.clear.cgColor
    favoritePlayerTextField.layer.borderColor = UIColor.clear.cgColor
    favoriteTeamTextField.layer.borderColor = UIColor.clear.cgColor
    aboutMeTextField.layer.borderColor = UIColor.clear.cgColor
    
    var image = UIImage(named: "back")
    image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateProfileTableViewController.backButtonPressed))
    self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState.normal)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateProfileTableViewController.registerUser))
    self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState.normal)
    self.navigationController?.navigationBar.barTintColor = UIColor(red:45.0/255.0, green:47.0/255.0, blue:43.0/255.0, alpha:1.0)
  }
  
  //MARK:- IBActions
  @IBAction func positionButtonPressed(_ sender: UIButton) {
    switch sender.tag {
    case 0:
      guardButton.isSelected = true
      forwardButton.isSelected = false
      centerButton.isSelected = false
    case 1:
      guardButton.isSelected = false
      forwardButton.isSelected = true
      centerButton.isSelected = false
    case 2:
      guardButton.isSelected = false
      forwardButton.isSelected = false
      centerButton.isSelected = true
    default:
      break
    }
  }
  
  @IBAction func changeProfileImage(_ sender: AnyObject) {
    showActionSheet()
  }
  
  func backButtonPressed(){
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  func registerUser() {
    //TO-DO Implement registration api, call already working
    
    if firstNameTextField.text != "" && lastNameTextField.text != "" &&
       homeCityTextField.text != "" && birthDateTextField.text != "" &&
       sexTextField.text != "", let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
      let userDictionary = ["email": emailAddress,
                            "password": password,
                            "password_confirmation": password,
                            "name": (firstName + " " + lastName) ?? "",
                            "nickname": "Test",
                            "image": "test",
                            "contact_number": "test",
                            "city": homeCityTextField.text ?? "",
                            "height": 1.23,
                            "weight": 1.25,
                            "birthday": "2012-10-24",
                            "gender": 0] as [String : Any]
      Utilities.showProgressHud(withTitle: "Registering User", inView: self.view)
      registrationViewModel.registerUser(userCredentials: userDictionary, completionBlock: { (responseCode, message) -> (Void) in
        Utilities.hideProgressHud()
        if responseCode == 201 || responseCode == 200 {
            self.showAlert(title: "SUCCESS", message: "User Successfully Registered! Please Login", callback: {self.navigationController?.popToRootViewController(animated: true)})
        } else if responseCode == 1{
          if let m = message {
            self.showAlert(title: "ERROR", message: m, callback: {})
          }
        } else {
          if let m = message {
            self.showAlert(title: "ERROR", message: m, callback: {})
          }
        }
      })
    
    } else {
      self.showAlert(title: "Error", message: "Please complete all fields", callback: {})
    }
    
    
    //pushToMainStoryboard()
  }
  
  func pushToMainStoryboard(){
    self.performSegue(withIdentifier: "LoginToMainSegue", sender: self)
    
  }
  
  func userDataToDictionary() {
    
  }
  
  
  func showActionSheet() {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
      self.camera()
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
      self.photoLibrary()
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    
    self.present(actionSheet, animated: true, completion: nil)
    
  }
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
}


extension CreateProfileTableViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
  func camera()  {
    imagePicker.delegate = self
    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
    
    self.present(imagePicker, animated: true, completion: nil)
    
  }
  
  func photoLibrary() {
    imagePicker.delegate = self
    imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    self.present(imagePicker, animated: true, completion: nil)
    
  }
  
  private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      userProfileImage.contentMode = .scaleToFill
      userProfileImage.image = pickedImage
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
}

