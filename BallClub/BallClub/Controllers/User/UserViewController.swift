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
    var firstTabSelected = true
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
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
    
    //MARK: - IBAction
    
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
  
  
  @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
  
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
            cell.setFriendUserName(name: TestClass.Common.friendNames[indexPath.row])
            cell.setFriendUserImage(image: TestClass.Common.friendImages[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestClass.Common.friendNames.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegue(withIdentifier: "FriendsProfileViewControllerSegue", sender: self)
    }
}

extension UserViewController : UITextFieldDelegate {
  @IBAction func editingChanged(textfield: UITextField) {
    //TODO:implement search
  }
}
