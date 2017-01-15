//
//  FriendStatusCustomCell.swift
//  BallClub
//
//  Created by Geraldine Forto on 31/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class FriendStatusCustomCell: UITableViewCell {
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userStatus: UIImageView!
  @IBOutlet weak var userPositionImageView: UIButton!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userCity: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setFriendUserName (name : String){
    userName.text = name
  }
  
  func setFriendUserImage (image : String){
    userImageView.image = UIImage(named: image)
  }
  
  func setuserCity (city : String) {
    userCity.text = city
  }
  
}
