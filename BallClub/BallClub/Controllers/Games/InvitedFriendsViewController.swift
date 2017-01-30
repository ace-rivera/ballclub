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
  
  var invitedPlayers: [Invite]? {
    didSet {
      self.sortInvites()
    }
  }
  var goingInvites = [Invite]()
  var notGoingInvites = [Invite]()
  var pendingInvites = [Invite]()
  
  var goingPlayers = [Player]()
  var notGoingPlayers = [Player]()
  var pendingPlayers = [Player]()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    setUpUI()
  }
  
  func setUpUI() {
    registerNibs()
  }
  
  func sortInvites() {
    if let invites = invitedPlayers {
      for invite in invites {
        switch invite.status {
        case 0:
          pendingInvites.append(invite)
        case 1:
          notGoingInvites.append(invite)
        case 2:
          goingInvites.append(invite)
        default:
          break
        }
      }
    }
    goingPlayers = Utilities.getInvitedPlayers(invites: self.goingInvites)
    notGoingPlayers = Utilities.getInvitedPlayers(invites: self.notGoingInvites)
    pendingPlayers = Utilities.getInvitedPlayers(invites: self.pendingInvites)
    
    self.tableView.reloadData()
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
      return self.goingPlayers.count
    case 1:
      return self.pendingPlayers.count
    case 2:
      return self.notGoingPlayers.count
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "InvitedFriendsCustomCell") as! InvitedFriendsCustomCell
    switch indexPath.section {
    case 0: //going
      cell.setImageOfFriend(imageUrlString: self.goingPlayers[indexPath.row].avatar ?? "")
      cell.setNameOfFriend(name: "\(self.goingPlayers[indexPath.row].firstName) \(self.goingPlayers[indexPath.row].lastName)")
      cell.setPositionOfFriend(position: self.goingPlayers[indexPath.row].position ?? "")
//      cell.setLoctionOfFriend(location: TestClass.Common.friendLocations[indexPath.row])
      
    case 1: //tentative
      cell.setImageOfFriend(imageUrlString: self.pendingPlayers[indexPath.row].avatar ?? "")
      cell.setNameOfFriend(name: "\(self.pendingPlayers[indexPath.row].firstName) \(self.goingPlayers[indexPath.row].lastName)")
      cell.setPositionOfFriend(position: self.pendingPlayers[indexPath.row].position ?? "")
//      cell.setLoctionOfFriend(location: TestClass.Common.friendLocations[indexPath.row])
      
    case 2: //invited
      cell.setImageOfFriend(imageUrlString: self.notGoingPlayers[indexPath.row].avatar ?? "")
      cell.setNameOfFriend(name: "\(self.notGoingPlayers[indexPath.row].firstName) \(self.goingPlayers[indexPath.row].lastName)")
      cell.setPositionOfFriend(position: self.notGoingPlayers[indexPath.row].position ?? "")
//      cell.setLoctionOfFriend(location: TestClass.Common.friendLocations[indexPath.row])
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
      return "PENDING"
    case 2:
      return "NOT GOING"
    default:
      return ""
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
}
