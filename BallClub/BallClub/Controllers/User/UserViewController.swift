//
//  UserViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var friendsTableView: UITableView!
  
  private var firstTabSelected = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func editProfilePressed(sender: AnyObject) {
    
  }
  
  @IBAction func settingsButtonPressed(sender: AnyObject) {
    
  }
  
  @IBAction func segmentTabChanged(segmentControl: UISegmentedControl) {
    let selectedSegment = segmentControl.selectedSegmentIndex;
    
    if selectedSegment == 0 {
      firstTabSelected = true
    }else{
      firstTabSelected = false
    }
    
    friendsTableView.reloadData()
  }
  
  
  //MARK: - TableView Delegate
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if firstTabSelected {
      let cell = tableView.dequeueReusableCellWithIdentifier("UserInviteCustomCell") as! UserInviteCustomCell
      cell.setFriendUserName(TestClass.Common.friendNames[indexPath.row])
      cell.setFriendUserImage(TestClass.Common.friendImages[indexPath.row])
      cell.setFriendInviteStatus("accepted your friend request")
      return cell
    }else{
      let cell = tableView.dequeueReusableCellWithIdentifier("UserAddFriendCustomCell") as! UserAddFriendCustomCell
      cell.setFriendUserName(TestClass.Common.friendNames[indexPath.row])
      cell.setFriendUserImage(TestClass.Common.friendImages[indexPath.row])
      return cell
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return TestClass.Common.friendNames.count
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
}
