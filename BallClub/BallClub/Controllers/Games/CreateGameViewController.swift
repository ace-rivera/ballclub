//
//  CreateGameViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class CreateGameViewController: UITableViewController,UICollectionViewDelegate, UICollectionViewDataSource {
  
  @IBOutlet var createGameTableView: UITableView!
  @IBOutlet weak var gameTitleTextField: UITextField!
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var startTimeButton: UIButton!
  @IBOutlet weak var endTimeButton: UIButton!
  @IBOutlet weak var playerCount: UITextField!
  @IBOutlet weak var feeTextField: UITextField!
  @IBOutlet weak var infoTextfield: UITextField!
  @IBOutlet weak var publicIcon: UIButton!
  @IBOutlet weak var publicButton: UIButton!
  @IBOutlet weak var privateIcon: UIButton!
  @IBOutlet weak var privateButton: UIButton!
  @IBOutlet weak var closedIcon: UIButton!
  @IBOutlet weak var closedButton: UIButton!
  @IBOutlet weak var friendsCollectionView: UICollectionView!
  @IBOutlet weak var reservedSwitch: UISwitch!
  @IBOutlet weak var approvalSwitch: UISwitch!
  
  var gameDetailsDict = [String : Any]()
  var selectedLocation: Location?
  var pickerView = UIView()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: - SetupUI
  func setUpUI(){
    self.friendsCollectionView.register(UINib(nibName: "FriendsRoundedCollectionCell",bundle: nil), forCellWithReuseIdentifier: "FriendsRoundedCollectionCell")
    self.createGameTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width:
      self.createGameTableView.bounds.size.width, height: 0.01)) //remove header - extra space above tableview
    publicIcon.isSelected = false
    publicButton.isSelected = false
  }
  
  //MARK: - Helper Methods
  func isFormValid() -> Bool {
    guard let title = self.gameTitleTextField.text,
      let location = self.selectedLocation, //needs improvement, should be from get location
      let startTime = self.startTimeButton.titleLabel?.text,
      let endTime = self.endTimeButton.titleLabel?.text,
      let fee = self.feeTextField.text else { return false }

    //create dictionary here
    self.gameDetailsDict["title"] = title
    self.gameDetailsDict["start_time"] = startTime
    self.gameDetailsDict["end_time"] = endTime
    self.gameDetailsDict["max_capacity"] = Int(self.playerCount.text ?? "")
    self.gameDetailsDict["fee"] = fee
    self.gameDetailsDict["additionalInfo"] = self.infoTextfield.text ?? ""
    self.gameDetailsDict["location_id"] = location.locationId

    return true
  }
  
  func datePickerValueChanged(sender:UIDatePicker) {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM dd, YYYY hh:mm a"
    
    if sender.tag == 1000 {
      self.startTimeButton.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    } else {
      self.endTimeButton.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }
  }
  
  func dismissDatePicker() {
    self.pickerView.removeFromSuperview()
  }
  
  //MARK: - IBAction
  @IBAction func doneButtonPressed(_ sender: AnyObject) {
    if isFormValid() {
      let gameViewModel = GamesViewModel()
      gameViewModel.createGame(gameDict: self.gameDetailsDict, completionBlock: { (statusCode, message, game) -> (Void) in
        if statusCode == Constants.ResponseCodes.STATUS_OK {
          self.showAlert(title: "Success", message: "Game created successfully", callback: {
            _ = self.navigationController?.popViewController(animated: true)
          })
        } else if statusCode == Constants.ResponseCodes.STATUS_MISSING_PARAMETERS {
          self.showAlert(title: "Error", message: "Please fill up all required fields", callback: {})
        } else {
          self.showAlert(title: "Error", message: "There was an error while creating the game", callback: {})
        }
      })
    } else {
      self.showAlert(title: "Error", message: "Please fill up all required fields", callback: {})
    }
  }
  
  @IBAction func backButtonPressed(_ sender: AnyObject) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func seeAllButtonPressed(_ sender: AnyObject) {
    
    
  }
  @IBAction func setTimePressed(_ sender: AnyObject) {
    let viewFrame = CGRect(x: 8, y: UIScreen.main.bounds.height/4,
                          width: UIScreen.main.bounds.width-16,
                          height: (UIScreen.main.bounds.height/3) + 50)
    self.pickerView = UIView(frame: viewFrame)
    self.pickerView.backgroundColor = UIColor.lightGray

    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .dateAndTime
    datePicker.tag = sender.tag

    let datePickerFrame = CGRect(x: 0, y: 0,
                       width: self.pickerView.frame.width,
                       height: self.pickerView.frame.height-40)
    datePicker.frame = datePickerFrame
    
    datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: .valueChanged)

    let doneButtonFrame = CGRect(x: 8, y: self.pickerView.frame.height-42,
                                 width: self.pickerView.frame.width-16,
                                 height: 34)
    let doneButton = UIButton(frame: doneButtonFrame)
    doneButton.layer.cornerRadius = 10
    doneButton.backgroundColor = UIColor.orange
    doneButton.setTitle("DONE", for: .normal)
    doneButton.addTarget(self, action: #selector(self.dismissDatePicker), for: .touchUpInside)
    
    self.pickerView.addSubview(datePicker)
    self.pickerView.addSubview(doneButton)
    
    self.view.addSubview(self.pickerView)
  }
  
  @IBAction func setGamePrivacy(_ button: UIButton) {
    publicIcon.isSelected = false
    publicButton.isSelected = false
    privateIcon.isSelected = false
    privateButton.isSelected = false
    closedIcon.isSelected = false
    closedButton.isSelected = false
    
    switch button.tag {
    case 0:
      publicIcon.isSelected = true
      publicButton.isSelected = true
    case 1:
      privateIcon.isSelected = true
      privateButton.isSelected = true
    case 2:
      closedIcon.isSelected = true
      closedButton.isSelected = true
    default:
      break
    }
    
  }
  
  @IBAction func reservedToggle(_ sender: AnyObject) {
    self.gameDetailsDict["reserved"] = reservedSwitch.isOn
  }
  
  @IBAction func approvalToggle(_ sender: AnyObject) {
    self.gameDetailsDict["approval"] = approvalSwitch.isOn
  }

  //MARK: - Collection View Delegate
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsRoundedCollectionCell", for: indexPath as IndexPath) as! FriendsRoundedCollectionCell
        collectionCell.setImageOfFriend(imageName: TestClass.Common.friendImages[indexPath.row])
        return collectionCell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TestClass.Common.friendImages.count
  }
}
