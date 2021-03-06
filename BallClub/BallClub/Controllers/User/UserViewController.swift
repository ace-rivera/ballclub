//
//  UserViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import Popover
import Nuke
import DZNEmptyDataSet

class UserViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    
    let friendsViewModel = FriendsViewModel()
    let playerViewModel = PlayerViewModel()
    
    var firstTabSelected = true
    var incomingRequestsArray = [Request]()
    var pendingFriendsList = [Player]()
    var pendingUserInvitesList = [Player]()
    var allPlayersArray = [Player]()
    var gameIvitesArray = [Invite]()
    var selectedUser: Player?
    var selectedRequest: Request!
    var resultSearchController: UISearchController? = nil
    var currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any]
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Utilities.showProgressHud(withTitle: "Loading User Details", inView: self.view)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any]
        getAllUsers()
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Utilities.hideProgressHud()
    }
    
    //MARK: - SetUpUI
    func setUpUI(){
        if let searchTable = self.storyboard?
            .instantiateViewController(withIdentifier: "userSearchResult") as? UserSearchResultTableViewController {
            resultSearchController = UISearchController(searchResultsController: searchTable)
            resultSearchController?.searchResultsUpdater = searchTable
            
            searchTable.playersArray = allPlayersArray
            searchTable.tempArray = allPlayersArray
            searchTable.friendRequestArray = incomingRequestsArray
            searchTable.delegate = self
        }
        
        
        if let searchBarController = self.resultSearchController {
            let searchBar = searchBarController.searchBar
            let searchBarFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40.0)
            
            searchBar.sizeToFit()
            searchBar.placeholder = "Search User"
            searchBar.frame = searchBarFrame
            
            self.searchView.addSubview(searchBar)
            
            searchBarController.hidesNavigationBarDuringPresentation = false
            searchBarController.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnCurrentUser))
        self.userProfileImage.addGestureRecognizer(tapGesture)
        self.playerName.addGestureRecognizer(tapGesture)
        self.userProfileImage.isUserInteractionEnabled = true
        self.playerName.isUserInteractionEnabled = true
        
        getUserData()
        registerNibs()
    }
    
    func registerNibs(){
        self.friendsTableView.register(UINib(nibName: "UserInviteCustomCell",bundle: nil), forCellReuseIdentifier: "UserInviteCustomCell")
        self.friendsTableView.register(UINib(nibName: "UserAddFriendCustomCell",bundle: nil), forCellReuseIdentifier: "UserAddFriendCustomCell")
        self.friendsTableView.register(UINib(nibName: "UserSearchFriendsCustomCell",bundle: nil), forCellReuseIdentifier: "UserSearchFriendsCustomCell")
    }
    
    
    //MARK: - get User Data
    func getUserData() {
        if let player = currentUser, let firstName = player["first_name"] as? String, let lastName = player["last_name"] as? String {
            self.playerName.text = firstName + " " + lastName
            
            if let urlString = player["avatar"] as? String,
                let url = URL(string: urlString) {
                Nuke.loadImage(with: url, into: self.userProfileImage)
            } else {
                self.userProfileImage.image = UIImage(named: "sample_profile")
            }
        }
        getPendingInvites()
    }
    
    // MARK: - Friend Requests API calls
    func getFriendRequests() {
        incomingRequestsArray.removeAll()
        friendsViewModel.getPendingRequests { (responseCode, message, incomingRequests, outgoingRequests, requestId, isFriendAdded) -> (Void) in
            
            if responseCode == 200 || responseCode == 201 {
                if let requests = incomingRequests {
                    self.incomingRequestsArray = requests
                    self.getInvitee()
                    self.setUpUI()
                }
            } else {
                Utilities.hideProgressHud()
                self.showAlert(title: "ERROR", message: message, callback: {})
            }
        }
    }
    
    func getInvitee() {
        pendingFriendsList.removeAll()
        for i in 0..<incomingRequestsArray.count {
            playerViewModel.getUser(userId: incomingRequestsArray[i].userId) { (responseCode, message, player) -> (Void) in
                if responseCode == 200 || responseCode == 201 {
                    if let p = player {
                        debugPrint("this is i", i)
                        self.pendingFriendsList.append(p)
                        
                        if i == self.incomingRequestsArray.count - 1 {
                            self.friendsTableView.reloadData()
                        }
                    }
                } else {
                    Utilities.hideProgressHud()
                    self.showAlert(title: "ERROR", message: message, callback: {})
                }
            }
        }
    
        if self.incomingRequestsArray.count == 0 {
            self.friendsTableView.reloadData()
        }
    }
    
    func getAllUsers() {
        playerViewModel.getAllUsers { (responseCode, message, playersArray) -> (Void) in
            if (responseCode == 200 || responseCode == 201), let players = playersArray {
                self.allPlayersArray =  players
                self.getFriendRequests()
            } else {
                Utilities.hideProgressHud()
                self.showAlert(title: "Error", message: message, callback: {})
            }
        }
    }
    
    func getPendingInvites() {
        gameIvitesArray.removeAll()
        friendsViewModel.getPendingIvites { (responseCode, message, inviteArray) -> (Void) in
            if (responseCode == 200 || responseCode == 201), let gameInvite = inviteArray {
                self.gameIvitesArray = gameInvite
                self.getGameInviteUsers()
            } else {
                Utilities.hideProgressHud()
                self.showAlert(title: "ERROR", message: message, callback: {})
            }
        }
    }
    
    func getGameInviteUsers() {
        pendingUserInvitesList.removeAll()
        for i in 0..<gameIvitesArray.count {
            playerViewModel.getUser(userId: gameIvitesArray[i].inviterId) { (responseCode, message, player) -> (Void) in
                if responseCode == 200 || responseCode == 201 {
                    if let p = player {
                        self.pendingUserInvitesList.append(p)
                        
                        if i == self.gameIvitesArray.count - 1 {               
                            self.friendsTableView.reloadData()
                            Utilities.hideProgressHud()
                        }
                        
                    }
                } else {
                    self.showAlert(title: "ERROR", message: message, callback: {})
                }
            }
        }
        
        if self.gameIvitesArray.count == 0 {
            Utilities.hideProgressHud()
            self.friendsTableView.reloadData()
        }
    }
    
    func didTapOnCurrentUser() {
        let filteredUser = self.allPlayersArray.filter {
            $0.playerId == currentUser?["id"] as? Int
        }
        if filteredUser.count > 0 {
            selectedUser = filteredUser.first!
        }
        self.performSegue(withIdentifier: "FriendsProfileViewControllerSegue", sender: self)
    }
    
    //MARK: - IBAction
    @IBAction func editProfilePressed(_ sender: AnyObject) {
        self.didTapOnCurrentUser()
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "pushSettingsVC", sender: self)
        
    }
    
    @IBAction func didTapOnProfileImage(_ sender: Any) {
        self.didTapOnCurrentUser()
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendsProfileViewControllerSegue" {
            let destinationNavigationController = segue.destination as! UINavigationController
            if let friendsVC: FriendsViewController = destinationNavigationController.topViewController as? FriendsViewController {
                if let user =  selectedUser {
                    friendsVC.player = user
                    friendsVC.selectedRequest = selectedRequest
                }
            }
        }
    }
    
}

extension UserViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if firstTabSelected {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserInviteCustomCell") as! UserInviteCustomCell
            cell.setFriendUserName(name: pendingUserInvitesList[indexPath.row].firstName + " " + pendingUserInvitesList[indexPath.row].lastName)
            if let imageString = pendingUserInvitesList[indexPath.row].avatar {
                cell.setFriendUserImage(image: imageString);
            }
            cell.setFriendInviteStatus(status: "has invited you to a game")
            cell.tag = indexPath.row
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserAddFriendCustomCell") as! UserAddFriendCustomCell
            cell.setFriendUserName(name: pendingFriendsList[indexPath.row].firstName + " " + pendingFriendsList[indexPath.row].lastName)
            if let imageString = pendingFriendsList[indexPath.row].avatar {
                cell.setFriendUserImage(image: imageString);
            }
            cell.tag = indexPath.row
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (pendingUserInvitesList.count == 0 || pendingFriendsList.count == 0) {
            self.initializeDelegates()
        }
        
        if firstTabSelected {
            if (self.pendingUserInvitesList.count == 0) {
                self.friendsTableView.separatorColor = UIColor.clear
            } else {
                self.friendsTableView.separatorColor = UIColor.lightGray
            }
            return pendingUserInvitesList.count
        } else {
            if (self.pendingFriendsList.count == 0) {
                self.friendsTableView.separatorColor = UIColor.clear
            } else {
                self.friendsTableView.separatorColor = UIColor.lightGray
            }
            return pendingFriendsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "FriendsProfileViewControllerSegue", sender: self)
    }
}

extension UserViewController : UserAddFriendCustomCellDelegate {
    func didTapOnUser(tag: Int) {
        self.selectedUser = pendingFriendsList[tag]
        self.selectedRequest = incomingRequestsArray[tag]
        self.performSegue(withIdentifier: "FriendsProfileViewControllerSegue", sender: self)
        
    }
    
    func didTapOnAcceptFriend (tag: Int) {
        self.selectedRequest = incomingRequestsArray[tag]
        
        friendsViewModel.acceptFriendRequest(requestId: self.selectedRequest.requestId) { (statusCode, message) -> (Void) in
            if statusCode == 200 || statusCode == 201 || statusCode == 204 {
                self.showAlert(title: "SUCCESS", message: "", callback: {})
                self.getFriendRequests()
            } else {
                if let m = message {
                    self.showAlert(title: "ERROR", message: m, callback: {})
                }
            }
        }
    }  
}

extension UserViewController : UserInviteCustomCellDelegate {
    func didTapOnInvitee(tag: Int) {
        self.selectedUser = pendingUserInvitesList[tag]
        self.performSegue(withIdentifier: "FriendsProfileViewControllerSegue", sender: self)
    }
    
    func didTapOnViewGame(tag: Int) {
        let storyBoard = UIStoryboard.init(name: "Game", bundle: nil)
        if let gameDetailsVC = storyBoard.instantiateViewController(withIdentifier: "gameDetailsVC") as? GameDetailViewController {
            gameDetailsVC.gameId =  gameIvitesArray[tag].gameId
            gameDetailsVC.inviteId = gameIvitesArray[tag].inviteId
            gameDetailsVC.gameCreatorId = pendingUserInvitesList[tag].playerId
            gameDetailsVC.loadGameDetail = true
            self.navigationController?.pushViewController(gameDetailsVC, animated: true)
        }
    }
}


extension UserViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func initializeDelegates() {
        self.friendsTableView.emptyDataSetSource = self
        self.friendsTableView.emptyDataSetDelegate = self
    }

    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var title = ""
        if (firstTabSelected) {
            title = "You have no pending game invites."
        } else {
            title = "No Friend requests as of this moment"
        }
        
        let myAttribute = [ NSForegroundColorAttributeName: UIColor.darkGray, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0) ]
        let myAttrString = NSAttributedString(string: title, attributes: myAttribute)
    
        return myAttrString
    }
}
