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
  @IBOutlet weak var gameFriendsCollection: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setDateOfGame(date: NSDate){
    gameDateLabel.text = String(date)//TODO: create formatter
  }
  
  func setTitleOfGame(title: String){
    gameTitle.text = title
  }
  
  func setCreatorOfGame(name: String){
    gameCreator.text = name
  }
  
  func setLocationOfGame(location: String){ //TODO: change to Location datatype
    gameLocation.text = location
  }
  
  func setTimeOfGame(startTime : String, endTime : String, amPm : String){
    gameTime.text = "\(startTime) - \(endTime) \(amPm)"
  }
  
  func setPriceOfGame(price: String){
    if price == "none"{
      gamePrice.hidden = true
      gamePriceIcon.hidden = true
    }else{
      gamePrice.text = price
    }
  }
  
  func setMemberCountOfGame(count: Int , maxCount : Int){
    gameMemberCount.text = "\(count)/\(maxCount)"
  }
  
  func setAttendeesOfGame(friends : [String]){ //TODO: change datatype to User - Friend
    if friends.count == 0 {
      gameFriends.hidden = true
      gameFriendsIcon.hidden = true
      gameFriendsCollection.hidden = true
    }else if friends.count >= 2 {
      gameFriends.text = "\(friends[0]) and \(friends[1]) are going"
    }else{
      gameFriends.text = "\(friends[0]) is going"
    }
  }
}
