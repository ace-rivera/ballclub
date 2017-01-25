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
  var friendsArray = [Player]()
  let friendsViewModel = FriendsViewModel()
  
  //MARK:- Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    segmentControl.addTarget(self, action: #selector(segmentTabChanged), for: .valueChanged)
    setupUI()
    self.getFriendsList()
  }
  
  //MARK:- SetupUI
  func setupUI(){
    userNameLabel.adjustsFontSizeToFitWidth = true
    userNameLabel.sizeToFit()
    addFriendButton.layer.borderColor = UIColor(red: 174.0/225.0, green: 174.0/225.0, blue:174.0/225.0, alpha:1.0).cgColor
    profileImage.layer.borderColor = UIColor.white.cgColor
    profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    
    
    setupProfileData()
    registerNibs()
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
  }
  
  func getFriendsList() {
    friendsViewModel.getFriendsList { (statusCode, message, players) -> (Void) in
      if statusCode == 200 || statusCode == 201 {
        if let p = players {
          self.friendsArray = p
          self.tableView.reloadData()
        }
      } else {
        if let m =  message {
          self.showAlert(title: "ERROR", message: m, callback: {})
        }
        
      }
    }
  }
  
  
  
  
  //MARK:- IBActions
  func segmentTabChanged(segmentControl: UISegmentedControl) {
    let selectedSegment = segmentControl.selectedSegmentIndex;
    
    if selectedSegment == 0 {
      tabSelected = 0
      self.tableView.rowHeight = 60
    }else if selectedSegment == 1{
      tabSelected = 1
      self.tableView.rowHeight = 150
    }else{
      tabSelected = 2
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
    friendsViewModel.createFriendRequest(friendId: 6) { (responseCode, message) -> (Void) in
      Utilities.hideProgressHud()
      if responseCode == 200 || responseCode == 201 {
        self.showAlert(title: "SUCCESS", message: "Friend Request Sent!", callback: {})
      } else {
        if let m =  message {
          self.showAlert(title: "ERROR", message: m, callback: {})
        }
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "FriendsProfileViewControllerSegue" {
      let destinationNavigationController = segue.destination as! UINavigationController
      if let friendsVC: FriendsViewController = destinationNavigationController.topViewController as? FriendsViewController {
          friendsVC.player = selectedUser
      }
    }
  }
  
}


extension FriendsViewController : UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tabSelected == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "UserInviteCustomCell") as! UserInviteCustomCell
      cell.setFriendUserName(name: TestClass.Common.friendNames[indexPath.row])
      cell.setFriendUserImage(image: TestClass.Common.friendImages[indexPath.row])
      cell.setFriendInviteStatus(status: "accepted your friend request")
      return cell
    }else if tabSelected == 1{
      let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCustomCell") as! FeedsCustomCell
//      cell.setDateOfGame(date: NSDate())
//      cell.setTitleOfGame(title: TestClass.Feeds.FeedTitle[indexPath.row])
//      cell.setCreatorOfGame(name: TestClass.Feeds.FeedCreator[indexPath.row])
//      cell.setLocationOfGame(location: TestClass.Feeds.FeedLocation[indexPath.row])
//      cell.setTimeOfGame(startTime: TestClass.Feeds.FeedStartTime[indexPath.row], endTime: TestClass.Feeds.FeedEndTime[indexPath.row], amPm: TestClass.Feeds.FeedAmPm[indexPath.row])
//      cell.setPriceOfGame(price: TestClass.Feeds.FeedPrice[indexPath.row])
//      cell.setMemberCountOfGame(count: TestClass.Feeds.FeedFriends[indexPath.row].count, maxCount: 10)
//      cell.setAttendeesOfGame(friends: TestClass.Feeds.FeedFriends[indexPath.row])
      return cell
    }else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "FriendStatusCustomCell") as! FriendStatusCustomCell
      cell.setFriendUserName(name: self.friendsArray[indexPath.row].firstName)
      cell.setuserCity(city: self.friendsArray[indexPath.row].city)
      if let imageString = self.friendsArray[indexPath.row].avatar {
        cell.setFriendUserImage(image: imageString)
      }
      cell.delegate = self
      cell.tag = indexPath.row
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tabSelected == 0 {
      return 3
    } else if tabSelected == 1 {
      return 3
    } else {
      return self.friendsArray.count
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
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
