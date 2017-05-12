//
//  GameDetailViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import Nuke
import MapKit

class GameDetailViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, EditGameTableViewControllerDelegate {
  
  @IBOutlet var gameDetailTableView: UITableView!
  
  @IBOutlet weak var locationImage: UIImageView!
  @IBOutlet weak var gameDate: UILabel!
  @IBOutlet weak var gameTitle: UILabel!
  @IBOutlet weak var gameLocation: UILabel!
  @IBOutlet weak var gamePrice: UILabel!
  @IBOutlet weak var gameTime: UILabel!
  @IBOutlet weak var gameDetails: UILabel!
  @IBOutlet weak var gameDetailsIcon: UIImageView!
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
  
  @IBOutlet weak var gameMap: MKMapView!
  
  @IBOutlet weak var goingPlayersLabel: UILabel!
  @IBOutlet weak var goingPlayerImage: UIImageView!
  
  @IBOutlet weak var invitedPlayersImage: UIImageView!
  @IBOutlet weak var invitedPlayersLabel: UILabel!
  @IBOutlet weak var isGameReservedLabel: UILabel!
  
  @IBOutlet weak var editGameButton: UIBarButtonItem!
  @IBOutlet weak var deleteGameButton: UIBarButtonItem!
  
  var gameId: Int? {
    didSet {
      if let gameId = self.gameId, let playerId = gameCreatorId {
        self.initializeGameDetails(userId: playerId, gameId: gameId)
      }
    }
  }
  var gameCreatorId: Int?
  var inviteId: Int?
  var isCurrentUsersGame = false
  var loadGameDetail = false // for non segue navigations
  var currentGameSelected: Game?
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
        let game = self.currentGameSelected {
        invitedFriendsVC.invitedPlayers = game.invites
      }
    } else if segue.identifier == "showEditViewController" {
      if let editVC: EditGameTableViewController = segue.destination as? EditGameTableViewController {
        if let id = gameId {
          editVC.gameId = id
          editVC.selectedGame = currentGameSelected
          editVC.friendsToInviteArray = invitedPlayers
          editVC.selectedLocation = currentGameSelected?.location
          editVC.delegate =  self
        }
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
    self.isGameReservedLabel.layer.borderColor = UIColor(red: 221.0/255.0, green: 86.0/255.0, blue: 42.0/255.0, alpha: 1).cgColor
    self.gameDate.layer.borderColor = UIColor.lightGray.cgColor
    
    if !isCurrentUsersGame {
      self.editGameButton.tintColor = UIColor.clear
      self.deleteGameButton.tintColor = UIColor.clear
    }
    
    if let gameId = self.gameId, let playerId = gameCreatorId, loadGameDetail {
      self.initializeGameDetails(userId: playerId, gameId: gameId)
    }
    
  }
  
  func setGameDetails() {
    if let game = self.currentGameSelected {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      if let start = dateFormatter.date(from: game.startTime),
        let end = dateFormatter.date(from: game.endTime){
        self.gameDate.text = CustomDateFormatter().gameDetailsTitleDateFormat(detailDate: start)
        self.gameTime.text = CustomDateFormatter().gameDetailsDateFormat(startTime: start, endTime: end)
      }
      
      self.gameLocation.text = game.location.locationName
      self.gameTitle.text = game.title
      self.gamePrice.text = String(format: "%.2f", game.fee)
      self.gamePrice.sizeToFit()
      self.playerCount.text = "\(game.maxCapacity)"
      self.gameOwner.text = "\(game.gameCreator.firstName) invited you"
      
      if game.invites.count > 0 {
        self.goingPlayers = Utilities.getGoingUsers(invites: game.invites)
        self.setAttendeesOfGame(friends: self.goingPlayers, maxPlayers: game.maxCapacity ?? 0)
        
        self.invitedPlayers = Utilities.getInvitedPlayers(invites: game.invites)
        self.setPendingInvites()
      }
      
      if game.privacy == 0 {
        self.gameDetails.text = "PUBLIC GAME hosted by \(game.gameCreator.firstName) \(game.gameCreator.lastName)"
        if let image = UIImage(named: "ic_public") {
          self.gameDetailsIcon.image = image
        }
      } else {
        self.gameDetails.text = "CLOSED GAME hosted by \(game.gameCreator.firstName) \(game.gameCreator.lastName)"
        if let image = UIImage(named: "ic_closed") {
          self.gameDetailsIcon.image = image
        }
      }
      
      self.isGameReservedLabel.text = (game.reserved ?? false) ? "RESERVED" : "PENDING"
      
      self.playerCount.text = "PLAYERS \(self.goingPlayers.count)/\(self.invitedPlayers.count)"
      self.additionInfo.text = game.additionalInfo ?? ""
      
      if let longitude = game.location.longitude,
        let latitude = game.location.latitude {
        self.setupGameLocation(latitude: latitude, longitude: longitude)
      }
    }
    
  }
  
  //MARK: - Helper Methods
  func initializeGameDetails(userId: Int, gameId: Int) {
    let gameViewModel = GamesViewModel()
    gameViewModel.getGameDetails(userId: userId, gameId: gameId) { (status, message, game) -> (Void) in
      if status == Constants.ResponseCodes.STATUS_OK {
        self.currentGameSelected = game
        self.setGameDetails()
        self.tableView.reloadData()
      } else {
        self.showAlert(title: "Error", message: "Unable to fetch game details", callback: {})
      }
    }
  }
  
  func setupGameLocation(latitude: String, longitude: String) {
    let latitudeValue = Double(latitude) ?? 0
    let longitudeValue = Double(longitude) ?? 0
    
    let coordinates = CLLocationCoordinate2D(latitude: latitudeValue, longitude: longitudeValue)
    let mkAnnotation = LocationAnnotation(coordinate: coordinates, title: "")
    
    self.gameMap.addAnnotation(mkAnnotation)
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let region = MKCoordinateRegion(center: mkAnnotation.coordinate, span: span)
    self.gameMap.setRegion(region, animated: true)
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
    // J.relova handle crash, as of now user can only join game when invited
    if let id = inviteId {
      if let currentUser = UserDefaults.standard.value(forKey: "currentUser") as? [String : Any],
        let userId = currentUser["id"] as? Int{
        var invite = ["status": status,
                      "membership": 1,
                      "user_id": userId] // get from current user Userdefaults
        friendsViewModel.updateInvite(inviteId: id, invite: invite) { (statusCode, message) -> (Void) in
          if statusCode ==  200 || statusCode == 201 {
            
          } else {
            if let m = message {
              self.showAlert(title: "ERROR", message: m, callback: {})
            }
            
          }
        }
      }
    } else {
      self.showAlert(title: "Error", message: "Cannot Join the game: Invite Only", callback: {})
    }
    
  }
  
  func setAttendeesOfGame(friends : [Player], maxPlayers: Int){
    if friends.count == 0 {
      self.goingPlayersLabel.text = "No one has yet to confirm"
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
    if let game = self.currentGameSelected {
      let pendingInvites = game.invites.filter {
        $0.status != 2
      }
      let pendingPlayers = Utilities.getInvitedPlayers(invites: pendingInvites)
      
      if pendingPlayers.count == 0 {
        self.invitedPlayersLabel.text = "You have not yet invited any users to this game!"
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
  
  
  @IBAction func didTapEditGame(_ sender: Any) {
    self.performSegue(withIdentifier: "showEditViewController", sender: self)
  }
  
  
  @IBAction func didTapDeleteGame(_ sender: Any) {
    self.showAlertWithDefaultButtons(title: "TimeOut!", message: "Are you sure you want to delete this gam?") {
      self.deleteGame()
    }
  }
  
  func deleteGame() {
    Utilities.showProgressHud(withTitle: "Deleting Game", inView: self.view)
    let gamesViewModel = GamesViewModel()
    if let id = gameId {
      gamesViewModel.deleteGame(gameId: id) { (responseCode, message) -> (Void) in
        Utilities.hideProgressHud()
        if responseCode == 204 {
          self.showAlert(title: "SUCCESS", message: "Game has been successfully deleted", callback: {self.navigationController?.popViewController(animated: true)})
          
        } else {
          self.showAlert(title: "ERROR", message: "Cannot Delete Game", callback: {})
        }
      }
    }
  }
  
  //MARK - Delegate Protocol Implementations
  func dismissViewController() {
    self.navigationController?.popViewController(animated: true)
  }
  
}
