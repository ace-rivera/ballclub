//
//  FriendsListCustomCell.swift
//  BallClub
//
//  Created by Joshua Relova on 1/16/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit

protocol FriendsListCustomCellDelegate {
  func didTapOnInviteFriend(tag: Int)
}

class FriendsListCustomCell: UITableViewCell {
  
  @IBOutlet weak var playerImage: UIImageView!
  @IBOutlet weak var playerName: UILabel!
  @IBOutlet weak var playerCity: UILabel!
  @IBOutlet weak var inviteButton: UIButton!
  
  var delegate : FriendsListCustomCellDelegate?
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func inviteFriend(_ sender: Any) {
    if let d = delegate {
      d.didTapOnInviteFriend(tag: self.tag)
    }
  }
}
