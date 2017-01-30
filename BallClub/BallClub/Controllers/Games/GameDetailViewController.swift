//
//  GameDetailViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import Nuke

class GameDetailViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  @IBOutlet var gameDetailTableView: UITableView!
  
  @IBOutlet weak var locationImage: UIImageView!
  @IBOutlet weak var gameDate: UILabel!
  @IBOutlet weak var gameTitle: UILabel!
  @IBOutlet weak var gameLocation: UILabel!
  @IBOutlet weak var gamePrice: UILabel!
  @IBOutlet weak var gameTime: UILabel!
  @IBOutlet weak var gameDetails: UILabel!
  @IBOutlet weak var playerCount: UILabel!
  @IBOutlet weak var playerNames: UILabel!
  @IBOutlet weak var gameOwner: UILabel!
  @IBOutlet weak var playerCollection: UICollectionView!
  @IBOutlet weak var additionInfo: UILabel!
  @IBOutlet weak var notGoingIcon: UIButton!
  @IBOutlet weak var notGoingButton: UIButton!
  @IBOutlet weak var tentativeIcon: UIButton!
  @IBOutlet weak var tentativeButton: UIButton!
  @IBOutlet weak var goingIcon: UIButton!
  @IBOutlet weak var goingButton: UIButton!
  
  
  @IBOutlet weak var goingPlayersLabel: UILabel!
  @IBOutlet weak var goingPlayerImage: UIImageView!
  
  @IBOutlet weak var invitedPlayersImage: UIImageView!
  @IBOutlet weak var invitedPlayersLabel: UILabel!
  
  var gameId: Int? {
    didSet {
      if let gameId = self.gameId {
        self.getGameDetails(gameId: gameId)
      }
    }
  }
  var game: Game?
  var inviteId: Int!
  var goingPlayers = [Player]()
  var invitedPlayers = [Player]()
  let friendsViewModel = FriendsViewModel()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "DetailToInvitedSegue" {
      if let invitedFriendsVC: InvitedFriendsViewController = segue.destination as? InvitedFriendsViewController,
          let game = self.game {
        invitedFriendsVC.invitedPlayers = game.invites
      }
    }
  }
  
  //MARK: - SetUpUI
  func setUpUI(){
    self.playerCollection.register(UINib(nibName: "FriendsRoundedCollectionCell",bundle: nil), forCellWithReuseIdentifier: "FriendsRoundedCollectionCell")
    self.gameDetailTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.gameDetailTableView.bounds.size.width, height: 0.01)) //remove header - extra space above tableview
    self.gameDetailTableView.estimatedRowHeight = 200
    self.gameDetailTableView.rowHeight = UITableViewAutomaticDimension
    additionInfo.sizeToFit()
  }
  
  func setGameDetails() {
    if let game = self.game {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      if let start = dateFormatter.date(from: game.startTime) {
        self.gameDate.text = CustomDateFormatter().feedsDateFormat(feedDate: start)
        self.gameTime.text = CustomDateFormatter().gameDetailsTimeFormat(startTime: start)
      }

      self.gameLocation.text = game.location.locationName
      self.gameTitle.text = game.title
      self.gamePrice.text = String(format: "%.2f", game.fee)
      self.gameDetails.text = game.additionalInfo ?? ""
      self.playerCount.text = "\(game.maxCapacity)"
      self.gameOwner.text = "\(game.gameCreator.firstName) invited you"
      
      if game.invites.count > 0 {
        self.goingPlayers = Utilities.getGoingUsers(invites: game.invites)
        self.setAttendeesOfGame(friends: self.goingPlayers)
        
        self.invitedPlayers = Utilities.getInvitedPlayers(invites: game.invites)
        self.setPendingInvites()
      }
      
      self.playerCount.text = "PLAYERS \(self.goingPlayers.count)/\(self.invitedPlayers.count)"
      self.additionInfo.text = game.additionalInfo ?? ""
    }
  }
  
  //MARK: - Helper Methods
  func getGameDetails(gameId: Int) {
    let gameViewModel = GamesViewModel()
    gameViewModel.getGameDetails(gameId: gameId) { (status, message, game) -> (Void) in
      if status == Constants.ResponseCodes.STATUS_OK {
        self.game = game
        self.setGameDetails()
        self.tableView.reloadData()
      } else {
        self.showAlert(title: "Error", message: "Unable to fetch game details", callback: {})
      }
    }
  }
  
  //MARK: - IBAction
  @IBAction func backButtonPressed(_ sender: AnyObject) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func seeAllButtonPressed(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "DetailToInvitedSegue", sender: self)
  }
  
  @IBAction func responseStatusButtonPressed(_ button: UIButton) {
    notGoingIcon.isSelected = false
    notGoingButton.isSelected = false
    tentativeIcon.isSelected = false
    tentativeButton.isSelected = false
    goingIcon.isSelected = false
    goingButton.isSelected = false
    
    switch button.tag {
    case 0:
      self.updateGameStatus(status: button.tag)
      notGoingIcon.isSelected = true
      notGoingButton.isSelected = true
    case 1:
      self.updateGameStatus(status: button.tag)
      tentativeIcon.isSelected = true
      tentativeButton.isSelected = true
    case 2:
      self.updateGameStatus(status: button.tag)
      goingIcon.isSelected = true
      goingButton.isSelected = true
    default:
      break
    }
    
  }
  
  @IBAction func suggestInviteButtonPressed(_ sender: AnyObject) {
    
  }
  
  //MARK: - Collection View Delegate
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsRoundedCollectionCell", for: indexPath as IndexPath) as! FriendsRoundedCollectionCell
    
    collectionCell.setImageOfFriend(imageUrlString: self.invitedPlayers[indexPath.row].avatar ?? "")
    return collectionCell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.invitedPlayers.count
  }
  
  func updateGameStatus(status: Int) {
    if let currentUser = UserDefaults.standard.value(forKey: "currentUser") as? [String : Any],
      let userId = currentUser["id"] as? Int{
      var invite = ["status": status,
                    "membership": 1,
                    "user_id": userId] // get from current user Userdefaults
      friendsViewModel.updateInvite(inviteId: inviteId, invite: invite) { (statusCode, message) -> (Void) in
        if statusCode ==  200 || statusCode == 201 {
          
        } else {
          if let m = message {
            self.showAlert(title: "ERROR", message: m, callback: {})
          }
          
        }
      }
    }
  }
  
  func setAttendeesOfGame(friends : [Player]){ //TODO: change datatype to User - Friend
    if friends.count == 0 {
      self.goingPlayersLabel.isHidden = true
    } else if friends.count == 2 {
      self.goingPlayersLabel.text = "\(friends[0].firstName) and \(friends[1].firstName) are going"
    } else if friends.count == 1 {
      self.goingPlayersLabel.text = "\(friends[0].firstName) is going"
    } else {
      self.goingPlayersLabel.text = "\(friends[0].firstName) and \(friends.count-1) others are going)"
    }
    if let imageUrl = URL(string: friends.first?.avatar ?? "") {
      Nuke.loadImage(with: imageUrl, into: self.goingPlayerImage)
    }
  }
  
  func setPendingInvites() {
    if let game = self.game {
      let pendingInvites = game.invites.filter {
        $0.status != 2
      }
      let pendingPlayers = Utilities.getInvitedPlayers(invites: pendingInvites)
      
      if pendingPlayers.count == 0 {
        self.invitedPlayersLabel.isHidden = true
      } else if pendingPlayers.count == 2 {
        self.invitedPlayersLabel.text = "\(pendingPlayers[0].firstName) and \(pendingPlayers[1].firstName) are invited"
      } else if pendingPlayers.count == 1 {
        self.invitedPlayersLabel.text = "\(pendingPlayers[0].firstName) is invited"
      } else {
        self.invitedPlayersLabel.text = "\(pendingPlayers[0].firstName), \(pendingPlayers[1].firstName) and \(pendingPlayers.count-2) others are invited)"
      }
      
      if let imageUrl = URL(string: pendingPlayers.first?.avatar ?? "") {
        Nuke.loadImage(with: imageUrl, into: self.invitedPlayersImage)
      }
      self.playerCollection.reloadData()
      self.displayAllInvites()
    }
  }
  
  func displayAllInvites() {
    var names = ""
    if self.invitedPlayers.count > 0 {
      for index in 0..<self.invitedPlayers.count-1 {
        names.append(self.invitedPlayers[index].firstName)
        names.append(", ")
      }
      if let lastPlayer = self.invitedPlayers.last {
        names.append(lastPlayer.firstName)
      }
    }
    
    self.playerNames.text = names
  }
}
