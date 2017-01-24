//
//  EditProfileTableViewController.swift
//  BallClub
//
//  Created by Joshua Relova on 9/7/16.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import DropDown
import Nuke

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {
  
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
  @IBOutlet weak var genderButton: UIButton!
 
  var imagePicker :  UIImagePickerController!
  var playerViewModel = PlayerViewModel()
  var currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any]
  var gender = 0
  var data = ""
  let dropDown = DropDown()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    super.viewWillAppear(animated)
    imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    setupUi()
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
    self.navigationController?.navigationBar.isHidden = false
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(EditProfileTableViewController.backButtonPressed))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EditProfileTableViewController.saveProfileChanges))
    self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState.normal)
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    
    
    dropDown.anchorView = self.genderButton
    dropDown.dataSource = ["Male", "Female"]
    dropDown.direction = .bottom
    dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
    dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.gender = index
      self.sexTextField.text = item
      self.dropDown.hide()
    }
    
    let datePicker = UIDatePicker.init()
    datePicker.datePickerMode = UIDatePickerMode.date
    datePicker.setDate(NSDate.init() as Date, animated: true)
    datePicker.addTarget(self, action: #selector(updateTextField), for: .valueChanged)
    self.birthDateTextField.inputView = datePicker
    
   populateUserData()
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
  
  @IBAction func didTapOnGenderField(_ sender: Any) {
    view.endEditing(true)
    dropDown.show()
  }
  
  func backButtonPressed(){
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  func saveProfileChanges() {
    
      if firstNameTextField.text != "" && lastNameTextField.text != "" &&
        homeCityTextField.text != "" && birthDateTextField.text != "" &&
        sexTextField.text != "" && heightTextField.text != "" && weightTextField.text != "",
        let firstName = firstNameTextField.text, let lastName = lastNameTextField.text,
        let height = heightTextField.text, let weight = weightTextField.text, let date = birthDateTextField.text, let city = homeCityTextField.text, let player = currentUser, let id = player["id"] as? Int {
        debugPrint("avatar", data)
      let userDictionary = ["name": (firstName + " " + lastName),
                            "nickname": "Test",
                            "avatar": data,
                            "contact_number": "test",
                            "city": city,
                            "height": Float(height) ?? 0,
                            "weight": Float(weight) ?? 0,
                            "birthday": date,
                            "gender": gender] as [String : Any]
      Utilities.showProgressHud(withTitle: "Registering User", inView: self.view)
      //TO-DO pass current user id in api call
      playerViewModel.updateUser(userId: id, userCredentials: userDictionary, completionBlock: { (responseCode, message) -> (Void) in
        Utilities.hideProgressHud()
        if responseCode == 200 || responseCode == 201 {
          self.showAlert(title: "SUCCESS", message: "User Profile has ben successfully updated", callback: {self.getCurrentUser(userId: id)})
        } else if responseCode ==  1 {
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
        self.showAlert(title: "ERROR", message: "All fields are required", callback: {})
    }
    
  }
  
  func getCurrentUser(userId: Int) {
    Utilities.showProgressHud(withTitle: "updateing user Profile", inView: self.view)
    self.playerViewModel.getUser(userId: userId, completionBlock: { (statusCode, message, player) -> (Void) in
      Utilities.hideProgressHud()
      if (statusCode == 200 || statusCode == 201), let p = player {
        UserDefaults.standard.set(Player.toDictionary(user: p), forKey: "currentUser")
        self.navigationController?.popViewController(animated: true)
      } else {
        self.showAlert(title: "ERROT", message: message, callback: {})
      }
    })
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
  
  func updateTextField() {
    let picker = self.birthDateTextField.inputView as? UIDatePicker
    self.birthDateTextField.text = self.dateFormatter(date: (picker?.date)!)
  }
  
  func dateFormatter(date: Date) -> String {
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateStyle = DateFormatter.Style.short
    let formattedString = dateFormatter.string(from: date)
    
    return formattedString
  }
  
  func populateUserData() {
    if let player = currentUser, let firstName = player["first_name"] as? String, let lastName = player["last_name"] as? String, let city = player["city"] as? String, let date = player["birthday"] as? String, let gender = player["gender"] as? Int, let weight = player["weight"] as? Float, let height = player["height"] as? Float {
      firstNameTextField.text = firstName
      lastNameTextField.text = lastName
      homeCityTextField.text = city
      birthDateTextField.text = date
      weightTextField.text = String(format: "%.2f", weight)
      heightTextField.text = String(format: "%.2f", height)

      if gender == 0 {
        sexTextField.text = "Male"
      } else {
        sexTextField.text = "Female"
      }
      
      if let urlString = player["avatar"] as? String,
        let url = URL(string: urlString) {
        Nuke.loadImage(with: url, into: self.userProfileImage)
      } else {
        self.userProfileImage.image = UIImage(named: "sample_profile")
      }
    }
  }
  
  // MARK: - Table view data source
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }

}

extension EditProfileTableViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      userProfileImage.contentMode = .scaleToFill
      userProfileImage.image = pickedImage
      
      
      if let imageData = UIImageJPEGRepresentation(pickedImage, 0.6) {
        let base64String = imageData.base64EncodedString(options: [])
        data = "data:image/jpeg;base64,"+base64String
      }
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
}
