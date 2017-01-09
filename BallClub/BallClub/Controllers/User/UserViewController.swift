//
//  UserViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var friendsTableView: UITableView!
  
  let friendsViewModel = FriendsViewModel()
  
  var firstTabSelected = true
  var friendsList = [Player]()
  var selectedUser: Player?
  
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
    getFriendsList()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: - SetUpUI
  func setUpUI(){
    self.searchTextField.layer.borderColor = UIColor.lightGray.cgColor
    registerNibs()
  }
  
  func registerNibs(){
    self.friendsTableView.register(UINib(nibName: "UserInviteCustomCell",bundle: nil), forCellReuseIdentifier: "UserInviteCustomCell")
    self.friendsTableView.register(UINib(nibName: "UserAddFriendCustomCell",bundle: nil), forCellReuseIdentifier: "UserAddFriendCustomCell")
  }
  
  func getFriendsList() {
    Utilities.showProgressHud(withTitle: "Loading", inView: self.view)
    friendsViewModel.getFriendsList { (responseCode, message, myFriends) -> (Void) in
      Utilities.hideProgressHud()
      if responseCode == 200 || responseCode == 201 {
        if let myFriendsArray = myFriends {
          self.friendsList = myFriendsArray
          self.friendsTableView.reloadData()
        }
      } else {
        if let m = message {
          self.showAlert(title: "ERROR", message: m, callback: {})
        }
      }
    }
  }
  
  
  //MARK: - IBAction
  @IBAction func editProfilePressed(_ sender: AnyObject) {
    
  }
  
  @IBAction func settingsButtonPressed(_sender: AnyObject) {
    
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
  
}

extension UserViewController : UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if firstTabSelected {
      let cell = tableView.dequeueReusableCell(withIdentifier: "UserInviteCustomCell") as! UserInviteCustomCell
      cell.setFriendUserName(name: TestClass.Common.friendNames[indexPath.row])
      cell.setFriendUserImage(image: TestClass.Common.friendImages[indexPath.row])
      cell.setFriendInviteStatus(status: "accepted your friend request")
      return cell
    }else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "UserAddFriendCustomCell") as! UserAddFriendCustomCell
      cell.setFriendUserName(name: friendsList[indexPath.row].playerName)
      cell.setFriendUserImage(image: TestClass.Common.friendImages[indexPath.row])
      cell.tag = indexPath.row
      cell.delegate = self
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if firstTabSelected {
      return TestClass.Common.friendNames.count
    } else {
      return friendsList.count
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //self.performSegue(withIdentifier: "FriendsProfileViewControllerSegue", sender: self)
  }
}

extension UserViewController : UITextFieldDelegate {
  @IBAction func editingChanged(_ textfield: UITextField) {
    //TODO:implement search
  }
}

extension UserViewController : UserAddFriendCustomCellDelegate {
  func didTapOnUser(tag: Int) {
    //push profile view controller
    self.selectedUser = friendsList[tag]
  }
}
