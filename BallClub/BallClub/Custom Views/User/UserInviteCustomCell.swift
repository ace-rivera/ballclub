//
//  UserInviteCustomCell.swift
//  BallClub
//
//  Created by Geraldine Forto on 31/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class UserInviteCustomCell: UITableViewCell {
  
  @IBOutlet weak var userProfileImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var inviteStatus: UILabel!
  @IBOutlet weak var viewGameButton: UIButton!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    viewGameButton.layer.borderColor = UIColor.lightGray.cgColor
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  //MARK:- Setters Getters
  func setFriendUserName (name : String){
    userName.text = name
  }
  
  func setFriendUserImage (image : String){
    userProfileImage.image = UIImage(named: image)
  }
  
  func setFriendInviteStatus (status : String) {
    inviteStatus.text = status
  }
  
  //MARK:- IBActions
  @IBAction func viewGameButtonPressed(_ sender: AnyObject) {
    
  }
}
