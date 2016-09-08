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
    
    private var tabSelected = 0
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    //MARK:- SetupUI
    func setupUI(){
        addFriendButton.layer.borderColor = UIColor(red: 174.0/225.0, green: 174.0/225.0, blue:174.0/225.0, alpha:1.0).CGColor
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor

        
        registerNibs()
    }
    
    func registerNibs(){
        self.tableView.registerNib(UINib(nibName: "UserInviteCustomCell",bundle: nil), forCellReuseIdentifier: "UserInviteCustomCell")
        self.tableView.registerNib(UINib(nibName: "FriendStatusCustomCell",bundle: nil), forCellReuseIdentifier: "FriendStatusCustomCell")
        self.tableView.registerNib(UINib(nibName: "FeedsCustomCell",bundle: nil), forCellReuseIdentifier: "FeedsCustomCell")
    }
    
    func setupProfileData() {
        
    }
    
    //MARK:- IBActions
    @IBAction func segmentTabChanged(segmentControl: UISegmentedControl) {
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
    
   
    @IBAction func backButtonPressed(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
    }
    
}


extension FriendsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tabSelected == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserInviteCustomCell") as! UserInviteCustomCell
            cell.setFriendUserName(TestClass.Common.friendNames[indexPath.row])
            cell.setFriendUserImage(TestClass.Common.friendImages[indexPath.row])
            cell.setFriendInviteStatus("accepted your friend request")
            return cell
        }else if tabSelected == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("FeedsCustomCell") as! FeedsCustomCell
            cell.setDateOfGame(NSDate())
            cell.setTitleOfGame(TestClass.Feeds.FeedTitle[indexPath.row])
            cell.setCreatorOfGame(TestClass.Feeds.FeedCreator[indexPath.row])
            cell.setLocationOfGame(TestClass.Feeds.FeedLocation[indexPath.row])
            cell.setTimeOfGame(TestClass.Feeds.FeedStartTime[indexPath.row], endTime: TestClass.Feeds.FeedEndTime[indexPath.row], amPm: TestClass.Feeds.FeedAmPm[indexPath.row])
            cell.setPriceOfGame(TestClass.Feeds.FeedPrice[indexPath.row])
            cell.setMemberCountOfGame(TestClass.Feeds.FeedFriends[indexPath.row].count, maxCount: 10)
            cell.setAttendeesOfGame(TestClass.Feeds.FeedFriends[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("FriendStatusCustomCell") as! FriendStatusCustomCell
            //cell.setFriendUserName(TestClass.Common.friendNames[indexPath.row])
            //cell.setFriendUserImage(TestClass.Common.friendImages[indexPath.row])
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
