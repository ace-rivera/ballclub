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
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    //MARK:- SetupUI
    func setupUI(){
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.sizeToFit()
        addFriendButton.layer.borderColor = UIColor(red: 174.0/225.0, green: 174.0/225.0, blue:174.0/225.0, alpha:1.0).cgColor
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2

        
        registerNibs()
    }
    
    func registerNibs(){
        self.tableView.register(UINib(nibName: "UserInviteCustomCell",bundle: nil), forCellReuseIdentifier: "UserInviteCustomCell")
        self.tableView.register(UINib(nibName: "FriendStatusCustomCell",bundle: nil), forCellReuseIdentifier: "FriendStatusCustomCell")
        self.tableView.register(UINib(nibName: "FeedsCustomCell",bundle: nil), forCellReuseIdentifier: "FeedsCustomCell")
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
    
   
    @IBAction func backButtonPressed(_ sender: AnyObject) {
      self.performSegue(withIdentifier: "unwindToUserStoryboard", sender: self)
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
            //Ace Rivera : TODO - fetch game
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendStatusCustomCell") as! FriendStatusCustomCell
            //cell.setFriendUserName(TestClass.Common.friendNames[indexPath.row])
            //cell.setFriendUserImage(TestClass.Common.friendImages[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
