//
//  CreateGameViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

protocol EditGameTableViewControllerDelegate {
  func dismissViewController()
}

class EditGameTableViewController: UITableViewController,UICollectionViewDelegate, UICollectionViewDataSource, InviteFriendsTableViewControllerDelegate, LocationListViewControllerDelegate {
  
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
  @IBOutlet weak var gameTypeDescriptionLabel: UILabel!
  
  var gameDetailsDict = [String : Any]()
  var friendsToInviteArray = [Player]()
  var selectedLocation: Location?
  var gamesViewModel = GamesViewModel()
  var pickerView = UIView()
  var resultSearchController: UISearchController? = nil
  var currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any]
  var gameId: Int!
  var selectedGame: Game?
  var delegate : EditGameTableViewControllerDelegate?
  var backGroundView = UIView()
  
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
    self.friendsCollectionView.register(UINib(nibName: "EditInvitedFriendsCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "EditInvitedFriendsCollectionViewCell")
    self.createGameTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width:
      self.createGameTableView.bounds.size.width, height: 0.01)) //remove header - extra space above tableview
    publicIcon.isSelected = false
    publicButton.isSelected = false
    
    privateButton.isHidden = true
    privateIcon.isHidden = true
    
    if let game = selectedGame {
      gameTitleTextField.text = game.title
      locationTextField.text = game.location.locationName
      if let isReserved = game.reserved {
        reservedSwitch.isOn = isReserved
      } else {
        reservedSwitch.isOn = false
      }
      playerCount.text = String(format: "%i", game.maxCapacity ?? 0)
      feeTextField.text = String(format: "%.2f", game.fee)
      infoTextfield.text = game.additionalInfo
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMMM dd, YYYY hh:mm a"
      
      
    }
  }
  
  //MARK: - Helper Methods
  func isFormValid() -> Bool {
    guard let title = self.gameTitleTextField.text,
      let location = self.selectedLocation, 
      let startTime = self.startTimeButton.titleLabel?.text,
      let endTime = self.endTimeButton.titleLabel?.text,
      let fee = self.feeTextField.text else { return false }
    
    //create dictionary here
    self.gameDetailsDict["title"] = title
    self.gameDetailsDict["start_time"] = startTime
    self.gameDetailsDict["end_time"] = endTime
    self.gameDetailsDict["max_capacity"] = Int(self.playerCount.text ?? "")
    self.gameDetailsDict["min_capacity"] = Int(self.playerCount.text ?? "")
    self.gameDetailsDict["fee"] = fee
    self.gameDetailsDict["additional_info"] = self.infoTextfield.text ?? ""
    self.gameDetailsDict["location_id"] = location.locationId
    self.gameDetailsDict["reserved"] = reservedSwitch.isOn
    
    
    
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
    self.backGroundView.removeFromSuperview()
  }
  
  func showInviteFriendsVC() {
    let storyboard = UIStoryboard.init(name: "Game", bundle: nil)
    if  let inviteFriendsTVC = storyboard.instantiateViewController(withIdentifier: "InviteFriendsTVC") as? InviteFriendsTableViewController {
      inviteFriendsTVC.delegate = self
      inviteFriendsTVC.currentInvitees = friendsToInviteArray
      inviteFriendsTVC.gameId = gameId
      inviteFriendsTVC.isFromEditVC =  true
      
      self.navigationController?.pushViewController(inviteFriendsTVC, animated: true)
    }
  }
  
  func getInviteFriendsArray(playerArray: [Player]) {
    friendsToInviteArray += playerArray
    self.friendsCollectionView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "createGameToAddLocation" {
      if let locationMapViewVC: LocationMapviewViewController = segue.destination as? LocationMapviewViewController {
        locationMapViewVC.delegate = self
      }
    } else {
        if let locationListVC: LocationListViewController = segue.destination as? LocationListViewController {
            locationListVC.delegate = self
        }
    }
  }
  
  
  
  //MARK: - IBAction
  @IBAction func doneButtonPressed(_ sender: AnyObject) {
    Utilities.showProgressHud(withTitle: "Updating Game", inView: self.view)
        if isFormValid() {
          let gameViewModel = GamesViewModel()
            gameViewModel.updateGame(gameId: gameId, gameDict: self.gameDetailsDict, completionBlock: { (statusCode, message, game) -> (Void) in
              if statusCode == Constants.ResponseCodes.STATUS_CREATED || statusCode == Constants.ResponseCodes.STATUS_OK {
                Utilities.hideProgressHud()
                self.showAlert(title: "Success", message: "Game successfully modified", callback: {
                  if let d = self.delegate {
                    d.dismissViewController()
                  }
                  _ = self.navigationController?.popViewController(animated: true)
                })
              } else if statusCode == Constants.ResponseCodes.STATUS_MISSING_PARAMETERS {
                Utilities.hideProgressHud()
                self.showAlert(title: "Error", message: "Please fill up all required fields", callback: {})
              } else {
                Utilities.hideProgressHud()
                self.showAlert(title: "Error", message: "There was an error while editing the game", callback: {})
              }
            })
          } else {
            Utilities.hideProgressHud()
            self.showAlert(title: "Error", message: "Please fill up all required fields", callback: {})
          }
  }
  
  @IBAction func backButtonPressed(_ sender: AnyObject) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  
  @IBAction func seeAllButtonPressed(_ sender: AnyObject) {
    
    
  }
  @IBAction func setTimePressed(_ sender: AnyObject) {
    self.backGroundView = UIView.init(frame: self.view.frame)
    backGroundView.backgroundColor = UIColor.clear
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
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector (self.dismissDatePicker))
    backGroundView.addGestureRecognizer(tapGestureRecognizer)
    
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
    
    self.view.addSubview(backGroundView)
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
      gameTypeDescriptionLabel.text = "Open to all, and any player can request to join"
    case 1:
      privateIcon.isSelected = true
      privateButton.isSelected = true
    case 2:
      closedIcon.isSelected = true
      closedButton.isSelected = true
      gameTypeDescriptionLabel.text = "Only invited players can see this game"
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
  
  @IBAction func didTapOnInviteFriends(_ sender: Any) {
    self.showInviteFriendsVC()
  }
  
  @IBAction func didTapOnLocationTextField(_ sender: Any) {
    self.performSegue(withIdentifier: "showLocationListVC", sender: self)
  }
  
  
  //MARK: - Collection View Delegate
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditInvitedFriendsCollectionViewCell", for: indexPath as IndexPath) as! EditInvitedFriendsCollectionViewCell
    collectionCell.setImageOfFriend(imageUrlString: self.friendsToInviteArray[indexPath.row].avatar ?? "")
    collectionCell.setUserName(userName: friendsToInviteArray[indexPath.row].firstName)
    return collectionCell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.friendsToInviteArray.count
  }
    
  func showSelectedLocation(location: Location) {
    selectedLocation = location
    locationTextField.text = location.locationName
  }
}

extension EditGameTableViewController: LocationMapViewDelegate {
  func locationSelected(location: Location) {
    self.locationTextField.text = location.locationName
    selectedLocation = location
  }
}
