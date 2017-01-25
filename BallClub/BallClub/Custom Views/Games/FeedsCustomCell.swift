//
//  FeedsCustomCell.swift
//  BallClub
//
//  Created by Geraldine Forto on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class FeedsCustomCell: UITableViewCell {
  
  @IBOutlet weak var gameDateLabel: UILabel!
  @IBOutlet weak var gameTitle: UILabel!
  @IBOutlet weak var gameCreator: UILabel!
  @IBOutlet weak var gameLocation: UILabel!
  @IBOutlet weak var gameTime: UILabel!
  @IBOutlet weak var gamePriceIcon: UIImageView!
  @IBOutlet weak var gamePrice: UILabel!
  @IBOutlet weak var gameMemberCount: UILabel!
  @IBOutlet weak var gameFriends: UILabel!
  @IBOutlet weak var gameFriendsIcon: UIImageView!
//  @IBOutlet weak var gameFriendsCollection: UICollectionView!
  
  var game: Game? {
    didSet {
      if let g = game {
        self.setupCellData(game: g)
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  //MARK: - UI Handling
  override func prepareForReuse() {
    self.gameDateLabel.text = ""
    self.gameTitle.text = ""
    self.gameCreator.text = ""
    self.gameLocation.text = ""
    self.gameTime.text = ""
    self.gamePrice.text = ""
    self.gameMemberCount.text = ""
    self.gameFriends.text = ""
    self.setNeedsLayout()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setupCellData(game: Game) {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    if let start = dateFormatter.date(from: game.startTime),
      let end = dateFormatter.date(from: game.endTime) {
      self.gameDateLabel.text = CustomDateFormatter().feedsDateFormat(feedDate: start)
      self.gameTime.text = CustomDateFormatter().gameDetailsDateFormat(startTime: start, endTime: end)
    }
    
    self.gameTitle.text = game.title
    self.gameCreator.text = game.gameCreator.firstName
    
    if game.fee > 0.0 {
      self.gamePrice.text = "\(game.fee)"
    } else {
      self.gamePrice.isHidden = true
      self.gamePriceIcon.isHidden = true
    }
    
    self.gameLocation.text = game.location.locationName
    
    self.setMemberCountOfGame(invitesArray: game.invites)
  }
  
 
  func setMemberCountOfGame(invitesArray: [Invite]) {
    var acceptedInvites = 0
    
    for invite in invitesArray {
      if invite.status == 2 {
        acceptedInvites += 1
      }
    }
    gameMemberCount.text = "\(acceptedInvites)/\(invitesArray.count)"
  }

//  func setAttendeesOfGame(friends : [String]){ //TODO: change datatype to User - Friend
//    if friends.count == 0 {
//      gameFriends.isHidden = true
//      gameFriendsIcon.isHidden = true
//    }else if friends.count >= 2 {
//      gameFriends.text = "\(friends[0]) and \(friends[1]) are going"
//    }else{
//      gameFriends.text = "\(friends[0]) is going"
//    }
//  }
}
