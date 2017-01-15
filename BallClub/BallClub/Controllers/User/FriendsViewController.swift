//
//  FriendsViewController.swift
//  BallClub
//
//  Created by Joshua  Relova on 07/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

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
    
    userNameLabel.text = player.playerName
    homeCityLabel.text = player.city
    registerNibs()
  }
  
  func registerNibs(){
    self.tableView.register(UINib(nibName: "UserInviteCustomCell",bundle: nil), forCellReuseIdentifier: "UserInviteCustomCell")
    self.tableView.register(UINib(nibName: "FriendStatusCustomCell",bundle: nil), forCellReuseIdentifier: "FriendStatusCustomCell")
    self.tableView.register(UINib(nibName: "FeedsCustomCell",bundle: nil), forCellReuseIdentifier: "FeedsCustomCell")
  }
  
  func setupProfileData() {
    
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
      debugPrint("HELLLO")
    }
    self.dismiss(animated: true, completion: {})
   // _ = self.navigationController?.popViewController(animated: true)
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
      cell.setDateOfGame(date: NSDate())
      cell.setTitleOfGame(title: TestClass.Feeds.FeedTitle[indexPath.row])
      cell.setCreatorOfGame(name: TestClass.Feeds.FeedCreator[indexPath.row])
      cell.setLocationOfGame(location: TestClass.Feeds.FeedLocation[indexPath.row])
      cell.setTimeOfGame(startTime: TestClass.Feeds.FeedStartTime[indexPath.row], endTime: TestClass.Feeds.FeedEndTime[indexPath.row], amPm: TestClass.Feeds.FeedAmPm[indexPath.row])
      cell.setPriceOfGame(price: TestClass.Feeds.FeedPrice[indexPath.row])
      cell.setMemberCountOfGame(count: TestClass.Feeds.FeedFriends[indexPath.row].count, maxCount: 10)
      cell.setAttendeesOfGame(friends: TestClass.Feeds.FeedFriends[indexPath.row])
      return cell
    }else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "FriendStatusCustomCell") as! FriendStatusCustomCell
      cell.setFriendUserName(name: self.friendsArray[indexPath.row].playerName)
      cell.setuserCity(city: self.friendsArray[indexPath.row].city)
      //cell.setFriendUserImage(TestClass.Common.friendImages[indexPath.row])
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
