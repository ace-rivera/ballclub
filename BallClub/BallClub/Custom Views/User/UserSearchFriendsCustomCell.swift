//
//  UserSearchFriendsCustomCell.swift
//  BallClub
//
//  Created by Joshua Relova on 1/12/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import Nuke

class UserSearchFriendsCustomCell: UITableViewCell {
  
  @IBOutlet weak var playerImageView: UIImageView!
  @IBOutlet weak var playerName: UILabel!
  @IBOutlet weak var homeCity: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  //MARK:- Setters Getters
  func setFriendUserName (name : String){
    playerName.text = name
    self.playerImageView.image = UIImage(named: "sample_profile")
  }
  
  func setFriendCity (city : String){
    homeCity.text = city
  }
  
  func setFriendUserImage (image : String){
    if let url = URL(string: image) {
      Nuke.loadImage(with: url, into: self.playerImageView)
    }
  }
  
}
