//
//  InvitedFriendsCustomCell.swift
//  BallClub
//
//  Created by Geraldine Forto on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class InvitedFriendsCustomCell: UITableViewCell {
  @IBOutlet weak var friendProfileImage: UIImageView!
  @IBOutlet weak var friendPosition: UIButton!
  @IBOutlet weak var friendName: UILabel!
  @IBOutlet weak var friendLocation: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  //MARK:- Setters Getters
  func setImageOfFriend(imageName : String) {
    friendProfileImage.image = UIImage(named: imageName)
  }
  
  func setPositionOfFriend(position : String) {
    friendPosition.setTitle(position, forState: .Normal)
  }
  
  func setNameOfFriend(name : String) {
    friendName.text = name
  }
  
  func setLoctionOfFriend(location : String) {
    friendLocation.text = location
  }
  
}
