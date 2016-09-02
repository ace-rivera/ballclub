//
//  UserAddFriendCustomCell.swift
//  BallClub
//
//  Created by Geraldine Forto on 31/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class UserAddFriendCustomCell: UITableViewCell {

  @IBOutlet weak var userProfileImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var acceptInvite: UIButton!
  @IBOutlet weak var declineInvite: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setFriendUserName (name : String){
    userName.text = name
  }
  
  func setFriendUserImage (image : String){
    userProfileImage.image = UIImage(named: image)
  }
  
  @IBAction func acceptFriend(sender: AnyObject) {
    
  }
  
  @IBAction func rejectFriend(sender: AnyObject) {
    
  }
}
