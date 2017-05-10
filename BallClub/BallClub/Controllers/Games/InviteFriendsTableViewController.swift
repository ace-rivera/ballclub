//
//  InviteFriendsTableViewController.swift
//  BallClub
//
//  Created by Joshua Relova on 1/16/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol InviteFriendsTableViewControllerDelegate {
  func getInviteFriendsArray(playerArray: [Player])
}

class InviteFriendsTableViewController: UITableViewController {
  
  var friendsViewModel = FriendsViewModel()
  var friendsArray = [Player]()
  var inviteFriendsArray = [Player]()
  var currentInvitees = [Player]()
  var gameId: Int?
  var selectedUser: Player?
  var delegate : InviteFriendsTableViewControllerDelegate?
  let inviteViewModel = FriendsViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Utilities.showProgressHud(withTitle: "Retrieveing Friends List", inView: self.view)
    friendsViewModel.getFriendsList { (responseCode, message, friends) -> (Void) in
      Utilities.hideProgressHud()
      if (responseCode ==  200 || responseCode == 201), let player = friends {
        self.friendsArray = player
    
        self.friendsArray = self.friendsArray.filter( {
            let id = $0.playerId
            return !self.currentInvitees.contains(where: {
                player in
                return player.playerId == id
            })
        })
        
        if (self.friendsArray.count <= 0) {
            self.initializeDelegates()
        }
        self.tableView.reloadData()
      } else {
        if let m = message {
          self.showAlert(title: "ERROR", message: m, callback: {})
        }
      }
    }
    self.friendsArray = [Player]()
    self.setupUI()
    self.registerNibs()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Table view data source
  func backButtonPressed(){
    if let d = delegate {
      d.getInviteFriendsArray(playerArray: inviteFriendsArray)
    }
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  func setupUI () {
    var image = UIImage(named: "back")
    image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(InviteFriendsTableViewController.backButtonPressed))
    self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState.normal)
  }
  
  func registerNibs() {
    self.tableView.register(UINib(nibName: "FriendsListCustomCell",bundle: nil), forCellReuseIdentifier: "FriendsListCustomCell")
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return friendsArray.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsListCustomCell") as? FriendsListCustomCell {
      cell.playerName.text = friendsArray[indexPath.row].firstName
      cell.playerCity.text = friendsArray[indexPath.row].city
      
      cell.tag = indexPath.row
      cell.delegate = self
      return cell
    } else {
      return UITableViewCell()
    }
  }
  
  
}

extension InviteFriendsTableViewController : FriendsListCustomCellDelegate {
  func didTapOnInviteFriend(tag: Int) {
    print("CELL #\(tag)")
    inviteFriendsArray.append(friendsArray[tag])
    if let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as? FriendsListCustomCell {
      cell.inviteButton.isEnabled = false
      cell.inviteButton.setTitle("Invited", for: .normal)
    }
  }
}

extension InviteFriendsTableViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func initializeDelegates() {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    
    // MARK: UI for empty data
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named:"noNotifs")
//    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "You have invited everyone on your friends list!"
        let myAttribute = [ NSForegroundColorAttributeName: UIColor.darkGray, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0) ]
        let myAttrString = NSAttributedString(string: title, attributes: myAttribute)

        return myAttrString
    }
}
