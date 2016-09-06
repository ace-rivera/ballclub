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
  
  override func viewDidLoad() {
    friendsTableView.registerNib(UINib(nibName: "InvitedFriendsCustomCell",bundle: nil), forCellReuseIdentifier: "InvitedFriendsCustomCell")
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("InvitedFriendsCustomCell") as! InvitedFriendsCustomCell
    switch indexPath.section {
    case 0: //going
      cell.setImageOfFriend(TestClass.Common.friendImages[indexPath.row])
      cell.setNameOfFriend(TestClass.Common.friendNames[indexPath.row])
      cell.setPositionOfFriend(TestClass.Common.friendPositions[indexPath.row])
      cell.setLoctionOfFriend(TestClass.Common.friendLocations[indexPath.row])
      
    case 1: //tentative
      cell.setImageOfFriend(TestClass.Common.friendImages[indexPath.row])
      cell.setNameOfFriend(TestClass.Game.tentativeFriends[indexPath.row])
      cell.setPositionOfFriend(TestClass.Common.friendPositions[indexPath.row])
      cell.setLoctionOfFriend(TestClass.Common.friendLocations[indexPath.row])
      
    case 2: //invited
      cell.setImageOfFriend(TestClass.Common.friendImages[indexPath.row])
      cell.setNameOfFriend(TestClass.Game.invitedFriends[indexPath.row])
      cell.setPositionOfFriend(TestClass.Common.friendPositions[indexPath.row])
      cell.setLoctionOfFriend(TestClass.Common.friendLocations[indexPath.row])
    default:
      break
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
}
