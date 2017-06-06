//
//  FriendsViewController.swift
//  BallClub
//
//  Created by Joshua  Relova on 07/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import Nuke
import DZNEmptyDataSet

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
  @IBOutlet weak var editButton: UIBarButtonItem!
  
  var tabSelected = 0
  var player: Player!
  var selectedUser : Player!
  var selectedRequest: Request!
  var selectedGameId: Int?
  var gameCreatorId: Int?
  var friendsArray = [Player]()
  var gamesArray = [Game]()
  let friendsViewModel = FriendsViewModel()
  let gamesViewModel = GamesViewModel()
  var currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any]
  
  //variables for getting selectedRequest when nil
  var pendingFriendRequests = [Request]()
  
  
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
    
    if (player.playerId != userId) {
     self.editButton.tintColor = UIColor.clear
    }
    
    if selectedRequest == nil && pendingFriendRequests.count > 0 {
      selectedRequest = getSelectedRequest(invites: pendingFriendRequests)
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
        let userId = self.currentUser?["id"] as? Int
        if((self.player.isFriend || (self.player.playerId == userId)) && g.count > 0) {
            self.gamesArray = g
        } else {
            self.initializeDelegates()
        }
        self.tableView.reloadData()
      } else {
        if let m = message {
          self.showAlert(title: "ERROR", message: m, callback: {})
        }
      }
    }
  }
  
  
  func getFriendRequests() {    
    friendsViewModel.getPendingRequests { (responseCode, message, incomingRequests, outgoingRequests, addedFriendID, isFriendAdded) -> (Void) in
      
      if responseCode == 200 || responseCode == 201 {
        
        if (self.player.playerId == addedFriendID) {
          self.addFriendButton.setTitle("Request Sent", for: .normal)
          self.addFriendButton.isEnabled = false
        } else if let requestSent = isFriendAdded {
            if (requestSent) {
                self.addFriendButton.setTitle("Accept Friend", for: .normal)
                self.addFriendButton.isEnabled = true
            }
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
    
    if (addFriendButton.titleLabel?.text == "Accept Friend") {
        // Accept Friend Request
        friendsViewModel.acceptFriendRequest(requestId: self.selectedRequest.requestId) { (statusCode, message) -> (Void) in
            if statusCode == 200 || statusCode == 201 || statusCode == 204 {
                self.showAlert(title: "SUCCESS", message: "You have successfully accepted this friend request", callback: {self.addFriendButton.isHidden = true})
                self.getFriendRequests()
                self.getFriendsList()
                self.getGamesList()
            } else {
                if let m = message {
                    self.showAlert(title: "ERROR", message: m, callback: {})
                }
            }
        }
    } else {
        //Send Friend Request/ Add Friend
        Utilities.showProgressHud(withTitle: "Sending Friend Request", inView: self.view)
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
   
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showGameDetailsVC" {
      if let gameDetailViewController: GameDetailViewController = segue.destination as? GameDetailViewController {
        if let gameId = self.selectedGameId, let playerId = self.gameCreatorId {
          gameDetailViewController.gameCreatorId = playerId
          gameDetailViewController.gameId = gameId
        }
      }
    } 
  }
  
  
  @IBAction func showEditVC(_ sender: Any) {
    self.performSegue(withIdentifier: "showEditVC", sender: self)
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
      cell.setFriendsPosition(position: self.friendsArray[indexPath.row].position ?? "G")
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
      if (self.gamesArray.count == 0) {
        self.tableView.separatorColor = UIColor.clear
      } else {
        self.tableView.separatorColor = UIColor.lightGray
      }
        
      return self.gamesArray.count
    } else {
      if (self.friendsArray.count == 0) {
        self.tableView.separatorColor = UIColor.clear
      } else {
        self.tableView.separatorColor = UIColor.darkGray
      }
      return self.friendsArray.count
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tabSelected ==  0 {
      self.selectedGameId = self.gamesArray[indexPath.row].gameId
      self.gameCreatorId = self.gamesArray[indexPath.row].gameCreator.playerId
      self.performSegue(withIdentifier: "showGameDetailsVC", sender: self)
    }
  }
  
  func getSelectedRequest(invites : [Request]) -> Request {

    for invite in invites {
      if let id = currentUser?["id"] as? Int {
        if id == invite.userId {
          return invite
        }
      }
    }
    
    return invites[0]
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

extension FriendsViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func initializeDelegates() {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    
    // MARK: UI for empty data
    //    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    //        return UIImage(named:"noNotifs")
    //    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var title = ""
        if (player.isFriend) {
          if tabSelected == 0 {
            title = player.firstName + " has no games as of the moment"
          } else {
            title = player.firstName + " currently has no friends"
          }
          
        } else {
            title = "Cannot View" + " " + player.firstName + "'s Games"  
        }
        
        let myAttribute = [ NSForegroundColorAttributeName: UIColor.darkGray, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0) ]
        let myAttrString = NSAttributedString(string: title, attributes: myAttribute)
        
        
        
        return myAttrString
    }
}
