//
//  InvitedFriendsViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class InvitedFriendsViewController: UITableViewController {
  
  @IBOutlet var friendsTableView: UITableView!
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    setUpUI()
  }
  
  func setUpUI() {
    registerNibs()
  }
  
  func registerNibs() {
    friendsTableView.register(UINib(nibName: "InvitedFriendsCustomCell",bundle: nil), forCellReuseIdentifier: "InvitedFriendsCustomCell")
  }
  
  //MARK: - IBAction
  @IBAction func backButtonPressed(_ sender: AnyObject) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  //MARK: - Tableview delegates
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return TestClass.Game.goingFriends.count
    case 1:
      return TestClass.Game.tentativeFriends.count
    case 2:
      return TestClass.Game.invitedFriends.count
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "InvitedFriendsCustomCell") as! InvitedFriendsCustomCell
    switch indexPath.section {
    case 0: //going
      cell.setImageOfFriend(imageName: TestClass.Common.friendImages[indexPath.row])
      cell.setNameOfFriend(name: TestClass.Common.friendNames[indexPath.row])
      cell.setPositionOfFriend(position: TestClass.Common.friendPositions[indexPath.row])
      cell.setLoctionOfFriend(location: TestClass.Common.friendLocations[indexPath.row])
      
    case 1: //tentative
      cell.setImageOfFriend(imageName: TestClass.Common.friendImages[indexPath.row])
      cell.setNameOfFriend(name: TestClass.Game.tentativeFriends[indexPath.row])
      cell.setPositionOfFriend(position: TestClass.Common.friendPositions[indexPath.row])
      cell.setLoctionOfFriend(location: TestClass.Common.friendLocations[indexPath.row])
      
    case 2: //invited
      cell.setImageOfFriend(imageName: TestClass.Common.friendImages[indexPath.row])
      cell.setNameOfFriend(name: TestClass.Game.invitedFriends[indexPath.row])
      cell.setPositionOfFriend(position: TestClass.Common.friendPositions[indexPath.row])
      cell.setLoctionOfFriend(location: TestClass.Common.friendLocations[indexPath.row])
    default:
      break
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "GOING"
    case 1:
      return "TENTATIVE"
    case 2:
      return "INVITED"
    default:
      return ""
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
//  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let view = UIView()
//    view.backgroundColor = UIColor.clearColor()
//    var label = UILabel()
//    label.textColor = Constants.CustomColor.tabBarBackgroundColor
//    view.addSubview(label)
//    
//    return view
//  }
  
}
