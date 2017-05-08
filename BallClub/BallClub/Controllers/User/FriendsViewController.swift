//
//  FriendsViewController.swift
//  BallClub
//
//  Created by Joshua  Relova on 07/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import Nuke

class FriendsViewController: UIViewController {
  
  @IBOutlet weak var statusImage: UIImageView!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var heightTextField: UITextField!
  @IBOutlet weak var weightTextField: UITextField!
  @IBOutlet weak var addFriendButton: UIButton!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var homeCityLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentControl: UISegmentedControl!
  
  var tabSelected = 0
  var player: Player!
  var selectedUser : Player!
  var selectedGameId: Int?
  var friendsArray = [Player]()
  var gamesArray = [Game]()
  let friendsViewModel = FriendsViewModel()
  let gamesViewModel = GamesViewModel()
  var currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any]
  
  //MARK:- Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Utilities.showProgressHud(withTitle: "Fetching User Data", inView: self.view)
    segmentControl.addTarget(self, action: #selector(segmentTabChanged), for: .valueChanged)
    setupUI()
  }
  
  //MARK:- Initial Setup
  func setupUI(){
    userNameLabel.adjustsFontSizeToFitWidth = true
    userNameLabel.sizeToFit()
    addFriendButton.layer.borderColor = UIColor(red: 174.0/225.0, green: 174.0/225.0, blue:174.0/225.0, alpha:1.0).cgColor
    profileImage.layer.borderColor = UIColor.white.cgColor
    profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    let userId = currentUser?["id"] as? Int
    
    if(player.isFriend || (player.playerId == userId)) {
      self.addFriendButton.isHidden = true;
    }
    
    
    setupProfileData()
    registerNibs()
    getFriendRequests()
  }
  
  func registerNibs(){
    self.tableView.register(UINib(nibName: "UserInviteCustomCell",bundle: nil), forCellReuseIdentifier: "UserInviteCustomCell")
    self.tableView.register(UINib(nibName: "FriendStatusCustomCell",bundle: nil), forCellReuseIdentifier: "FriendStatusCustomCell")
    self.tableView.register(UINib(nibName: "FeedsCustomCell",bundle: nil), forCellReuseIdentifier: "FeedsCustomCell")
  }
  
  func setupProfileData() {
    userNameLabel.text = player.firstName + " " + player.lastName
    homeCityLabel.text = player.city
    heightTextField.text = String(format: "%.2f", player.height ?? "180") + " " + "cm"
    weightTextField.text = String(format: "%.2f", player.weight ?? "180") + " " + "lbs"
    
    if let url = URL(string: player.avatar ?? "") {
      Nuke.loadImage(with: url, into: self.profileImage)
    }
    
    self.getFriendsList()
    self.getGamesList()
  }
  
  //MARK: API Calls
  func getFriendsList() {
    friendsViewModel.getUserFriendsList(userId: player.playerId) { (statusCode, message, players) -> (Void) in
      if statusCode == 200 || statusCode == 201 {
        if let p = players {
          self.friendsArray = p
          //self.tableView.reloadData()
        }
      } else {
        if let m =  message {
          Utilities.hideProgressHud()
          self.showAlert(title: "ERROR", message: m, callback: {})
        }
        
      }
    }
  }
  
  func getGamesList() {
    gamesViewModel.getCurrentUserGames(userId: player.playerId) { (statusCode, message, games) -> (Void) in
      Utilities.hideProgressHud()
      if (statusCode == 200 || statusCode == 201), let g = games {
        self.gamesArray = g
        self.tableView.reloadData()
      } else {
        if let m = message {
          self.showAlert(title: "ERROR", message: m, callback: {})
        }
      }
    }
  }
  
  
  func getFriendRequests() {    
    friendsViewModel.getPendingRequests { (responseCode, message, incomingRequests, outgoingRequests, addedFriendID) -> (Void) in
      
      if responseCode == 200 || responseCode == 201 {
        
        if (self.player.playerId == addedFriendID) {
          self.addFriendButton.setTitle("Request Sent", for: .normal)
          self.addFriendButton.isEnabled = false
        }
        
      } else {
        Utilities.hideProgressHud()
        self.showAlert(title: "ERROR", message: message, callback: {})
      }
    }
  }
  
  //MARK:- IBActions
  func segmentTabChanged(segmentControl: UISegmentedControl) {
    let selectedSegment = segmentControl.selectedSegmentIndex
    
    if selectedSegment == 0{
      tabSelected = 0
      self.tableView.rowHeight = 150
    }else{
      tabSelected = 1
      self.tableView.rowHeight = 60
    }
    
    tableView.reloadData()
  }
  
  @IBAction func backButtonPressed(_ sender: AnyObject) {
    
    if (self.navigationController?.viewControllers.count)! >= 2 {
      _ = self.navigationController?.popViewController(animated: true)
    } else {
      self.dismiss(animated: true, completion: {})
    }
  }
  
  
  @IBAction func didTapOnAddFriendButton(_ sender: Any) {
    Utilities.showProgressHud(withTitle: "Sending Friend REquest", inView: self.view)
    friendsViewModel.createFriendRequest(friendId: player.playerId) { (responseCode, message) -> (Void) in
      Utilities.hideProgressHud()
      if responseCode == 200 || responseCode == 201 {
        self.showAlert(title: "SUCCESS", message: "Friend Request Sent!", callback: {})
        self.addFriendButton.setTitle("Request Sent", for: .normal)
        self.addFriendButton.isEnabled = false
      } else if responseCode ==  422 {
        self.showAlert(title: "ERROR", message: "Friend Request already sent", callback: {})
      } else {
        self.showAlert(title: "ERROR", message: "Unable to send Friend Request", callback: {})
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "GameDetailSegue" {
      if let gameDetailViewController: GameDetailViewController = segue.destination as? GameDetailViewController {
        if let id = self.selectedGameId {
          gameDetailViewController.gameId = id
        }
      }
    }
  }
  
}


extension FriendsViewController : UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if tabSelected == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCustomCell") as! FeedsCustomCell
      cell.selectionStyle = .none
      cell.game = self.gamesArray[indexPath.row]
      self.tableView.rowHeight = 150
      return cell
    }else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "FriendStatusCustomCell") as! FriendStatusCustomCell
      cell.setFriendUserName(name: self.friendsArray[indexPath.row].firstName)
      cell.setuserCity(city: self.friendsArray[indexPath.row].city)
      if let imageString = self.friendsArray[indexPath.row].avatar {
        cell.setFriendUserImage(image: imageString)
      }
      cell.selectionStyle = .none
      cell.delegate = self
      cell.tag = indexPath.row
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if tabSelected == 0 {
      return self.gamesArray.count
    } else {
      return self.friendsArray.count
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tabSelected ==  0 {
      self.selectedGameId = self.gamesArray[indexPath.row].gameId
      let storyboard = UIStoryboard.init(name: "Game", bundle: nil)
      if  let gamesVC = storyboard.instantiateViewController(withIdentifier: "gameDetailsVC") as? GameDetailViewController {
        if let id = self.selectedGameId {
          gamesVC.gameId = id
          self.navigationController?.pushViewController(gamesVC, animated: true)
        }
        
      }
    }
  }
}


extension FriendsViewController : FriendStatusCustomCellDelegate {
  func didTapOnUser(tag: Int){
    self.selectedUser = self.friendsArray[tag]
    let storyboard = UIStoryboard.init(name: "Friends", bundle: nil)
    if  let friendsVC = storyboard.instantiateViewController(withIdentifier: "FriendsProfileVC") as? FriendsViewController {
      friendsVC.player = selectedUser
      self.navigationController?.pushViewController(friendsVC, animated: true)
    }
  }
}
