//
//  GameDetailViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

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
  
  var gameId: Int? {
    didSet {
      if let gameId = self.gameId {
        self.getGameDetails(gameId: gameId)
      }
    }
  }
  var game: Game?
  var inviteId: Int!
  let friendsViewModel = FriendsViewModel()
  
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
//      self.playerNames.text =
//      self.additionInfo.text = //Ace: For what?
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
    collectionCell.setImageOfFriend(imageName: TestClass.Common.friendImages[indexPath.row])
    return collectionCell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TestClass.Common.friendImages.count
  }
  
  func updateGameStatus(status: Int) {
    var invite = ["status": status,
                  "membership": 1,
                  "user_id": 2] // get from current user Userdefaults
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
