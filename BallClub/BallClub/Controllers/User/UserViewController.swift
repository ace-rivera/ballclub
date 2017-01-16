//
//  UserViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import Popover

class UserViewController: UIViewController {
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var friendsTableView: UITableView!
  @IBOutlet weak var searchView: UIView!
  @IBOutlet weak var playerName: UILabel!

  
  let friendsViewModel = FriendsViewModel()
  let playerViewModel = PlayerViewModel()
  
  var firstTabSelected = true
  var incomingRequestsArray = [Request]()
  var pendingFriendsList = [Player]()
  var pendingUserInvitesList = [Player]()
  var allPlayersArray = [Player]()
  var gameIvitesArray = [Invite]()
  var selectedUser: Player?
  var selectedRequest: Request!
  var resultSearchController: UISearchController? = nil
  var currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any]
  
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    getAllUsers()
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    Utilities.showProgressHud(withTitle: "Loading User Data", inView: self.view)
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any]
    setUpUI()
    getPendingInvites()
    getFriendRequests()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    Utilities.hideProgressHud()
  }
  
  //MARK: - SetUpUI
  func setUpUI(){
    self.searchTextField.layer.borderColor = UIColor.lightGray.cgColor
    
    
    if let searchTable = self.storyboard?
      .instantiateViewController(withIdentifier: "userSearchResult") as? UserSearchResultTableViewController {
      resultSearchController = UISearchController(searchResultsController: searchTable)
      resultSearchController?.searchResultsUpdater = searchTable
      
      //searchTable.mapView = mapView
      searchTable.delegate = self
    }
    
    
    if let searchBarController = self.resultSearchController {
      let searchBar = searchBarController.searchBar
      let searchBarFrame = CGRect(x: 0, y: 15.0, width: UIScreen.main.bounds.width, height: 40.0)
      
      searchBar.sizeToFit()
      searchBar.placeholder = "Type Location"
      searchBar.frame = searchBarFrame
      
      self.searchView.addSubview(searchBar)
      
      searchBarController.hidesNavigationBarDuringPresentation = true
      searchBarController.dimsBackgroundDuringPresentation = true
      definesPresentationContext = true
    }
    
    getUserData()
    registerNibs()
  }
  
  func registerNibs(){
    self.friendsTableView.register(UINib(nibName: "UserInviteCustomCell",bundle: nil), forCellReuseIdentifier: "UserInviteCustomCell")
    self.friendsTableView.register(UINib(nibName: "UserAddFriendCustomCell",bundle: nil), forCellReuseIdentifier: "UserAddFriendCustomCell")
    self.friendsTableView.register(UINib(nibName: "UserSearchFriendsCustomCell",bundle: nil), forCellReuseIdentifier: "UserSearchFriendsCustomCell")
  }
  
  func getUserData() {
    if let player = currentUser, let name = player["name"] as? String {
      self.playerName.text = name
    }
  }
  
  // User pending friend requests
  func getFriendRequests() {
    incomingRequestsArray.removeAll()
    friendsViewModel.getPendingRequests { (responseCode, message, incomingRequests, outgoingRequests) -> (Void) in
      
      if responseCode == 200 || responseCode == 201 {
        if let requests = incomingRequests {
          self.incomingRequestsArray = requests
          self.getInvitee()
        }
      } else {
        Utilities.hideProgressHud()
        self.showAlert(title: "ERROR", message: message, callback: {})
      }
    }
  }
  
  
  func getInvitee() {
    pendingFriendsList.removeAll()
    for i in 0..<incomingRequestsArray.count {
      playerViewModel.getUser(userId: incomingRequestsArray[i].userId) { (responseCode, message, player) -> (Void) in
        if responseCode == 200 || responseCode == 201 {
          if let p = player {
            debugPrint("this is i", i)
            self.pendingFriendsList.append(p)
            
            if i == self.incomingRequestsArray.count - 1 {
              Utilities.hideProgressHud()
              self.friendsTableView.reloadData()
            }
          }
        } else {
          Utilities.hideProgressHud()
          self.showAlert(title: "ERROR", message: message, callback: {})
        }
      }
    }
    
    if self.incomingRequestsArray.count == 0 {
      Utilities.hideProgressHud()
      self.friendsTableView.reloadData()
    }
  }
  
  //User invited games
  func getPendingInvites() {
    gameIvitesArray.removeAll()
    friendsViewModel.getPendingIvites { (responseCode, message, inviteArray) -> (Void) in
      if (responseCode == 200 || responseCode == 201), let gameInvite = inviteArray {
        self.gameIvitesArray = gameInvite
        self.getGameInviteUsers()
      } else {
        Utilities.hideProgressHud()
        self.showAlert(title: "ERROR", message: message, callback: {})
      }
    }
  }
  
  func getGameInviteUsers() {
    pendingUserInvitesList.removeAll()
    for i in 0..<gameIvitesArray.count {
      playerViewModel.getUser(userId: gameIvitesArray[i].inviterId) { (responseCode, message, player) -> (Void) in
        if responseCode == 200 || responseCode == 201 {
          if let p = player {
            self.pendingUserInvitesList.append(p)
            
            if i == self.gameIvitesArray.count - 1 {
              Utilities.hideProgressHud()
              self.friendsTableView.reloadData()
            }
            
          }
        } else {
          self.showAlert(title: "ERROR", message: message, callback: {})
        }
      }
    }
    
    if self.gameIvitesArray.count == 0 {
      Utilities.hideProgressHud()
      self.friendsTableView.reloadData()
    }
  }
  
  func getAllUsers() {
    playerViewModel.getAllUsers { (responseCode, message, playersArray) -> (Void) in
      if (responseCode == 200 || responseCode == 201), let players = playersArray {
        self.allPlayersArray =  players
      } else {
        self.showAlert(title: "Error", message: message, callback: {})
      }
    }
  }
  
  
  
  
  //MARK: - IBAction
  @IBAction func editProfilePressed(_ sender: AnyObject) {
    
  }
 
  @IBAction func settingsButtonPressed(_ sender: Any) {
    self.performSegue(withIdentifier: "pushSettingsVC", sender: self)
    
  }

  @IBAction func segmentTabChanged(_ segmentControl: UISegmentedControl) {
    let selectedSegment = segmentControl.selectedSegmentIndex;
    
    if selectedSegment == 0 {
      firstTabSelected = true
    }else{
      firstTabSelected = false
    }
    
    friendsTableView.reloadData()
  }
  
  
  @IBAction func unwindToMenu(_segue: UIStoryboardSegue) {}
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "FriendsProfileViewControllerSegue" {
      let destinationNavigationController = segue.destination as! UINavigationController
      if let friendsVC: FriendsViewController = destinationNavigationController.topViewController as? FriendsViewController {
        if let user =  selectedUser {
          friendsVC.player = user
        }
      }
    }
  }
  
}

extension UserViewController : UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if firstTabSelected {
      let cell = tableView.dequeueReusableCell(withIdentifier: "UserInviteCustomCell") as! UserInviteCustomCell
      cell.setFriendUserName(name: pendingUserInvitesList[indexPath.row].playerName)
      cell.setFriendUserImage(image: TestClass.Common.friendImages[indexPath.row])
      cell.setFriendInviteStatus(status: "accepted your friend request")
      cell.tag = indexPath.row
      cell.delegate = self
      return cell
    }else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "UserAddFriendCustomCell") as! UserAddFriendCustomCell
      cell.setFriendUserName(name: pendingFriendsList[indexPath.row].playerName)
      cell.setFriendUserImage(image: TestClass.Common.friendImages[indexPath.row])
      cell.tag = indexPath.row
      cell.delegate = self
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if firstTabSelected {
      return pendingUserInvitesList.count
    } else {
      return pendingFriendsList.count
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //self.performSegue(withIdentifier: "FriendsProfileViewControllerSegue", sender: self)
  }
}

extension UserViewController : UserAddFriendCustomCellDelegate {
  func didTapOnUser(tag: Int) {
    //push profile view controller
    self.selectedUser = pendingFriendsList[tag]
    let storyBoard = UIStoryboard.init(name: "Friends", bundle: nil)
    if let friendsVC = storyBoard.instantiateViewController(withIdentifier: "FriendsProfileVC") as? FriendsViewController {
      self.navigationController?.pushViewController(friendsVC, animated: true)
    }
    
  }
  
  func didTapOnAcceptFriend (tag: Int) {
    self.selectedRequest = incomingRequestsArray[tag]
    
    friendsViewModel.acceptFriendRequest(requestId: self.selectedRequest.requestId) { (statusCode, message) -> (Void) in
      if statusCode == 200 || statusCode == 201 || statusCode == 204 {
        self.showAlert(title: "SUCCESS", message: "", callback: {})
        self.getFriendRequests()
      } else {
        if let m = message {
          self.showAlert(title: "ERROR", message: m, callback: {})
        }
      }
    }
  }  
}

extension UserViewController : UserInviteCustomCellDelegate {
  func didTapOnInvitee(tag: Int) {
    self.selectedUser = pendingUserInvitesList[tag]
    self.performSegue(withIdentifier: "FriendsProfileViewControllerSegue", sender: self)
  }
  
  func didTapOnViewGame(tag: Int) {
    let storyBoard = UIStoryboard.init(name: "Game", bundle: nil)
    if let gameDetailsVC = storyBoard.instantiateViewController(withIdentifier: "gameDetailsVC") as? GameDetailViewController {
      gameDetailsVC.inviteId = gameIvitesArray[tag].inviteId
      self.navigationController?.pushViewController(gameDetailsVC, animated: true)
    }
  }
}

extension UserViewController : UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.showPopOverFromView(view: textField)
  }
  
  func showPopOverFromView(view: UIView) {
    let tableView = UITableView(frame: CGRect(x: 0, y: 0,
                                              width: self.searchTextField.frame.size.width,
                                              height: 200))
    
    let options = [
      .type(.down),
      .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
      ] as [PopoverOption]
    let popover = CustomPopover(options: options, showHandler: nil, dismissHandler: nil)
    
    popover.delegate = self
    tableView.delegate = popover
    tableView.dataSource = popover
    tableView.backgroundColor = .white
    tableView.isScrollEnabled = true
    
    popover.show(tableView, fromView: view)
  }
}

class CustomPopover: Popover, UITableViewDelegate, UITableViewDataSource {
  // MARK: - Table view data source
  var delegate: UserViewController?
  var playersArray = [Player]()
  
  
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
     tableView.register(UINib(nibName: "UserSearchFriendsCustomCell",bundle: nil), forCellReuseIdentifier: "UserSearchFriendsCustomCell")
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let d = delegate {
      playersArray = d.allPlayersArray
      return d.allPlayersArray.count
    } else {
      return 2
    }
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchFriendsCustomCell", for: indexPath) as? UserSearchFriendsCustomCell {
      cell.setFriendUserName(name: playersArray[indexPath.row].playerName)
      cell.setFriendUserImage(image: TestClass.Common.friendImages[indexPath.row])
      cell.tag = indexPath.row
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}
