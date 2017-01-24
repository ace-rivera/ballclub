//
//  UserInviteCustomCell.swift
//  BallClub
//
//  Created by Geraldine Forto on 31/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import Nuke

protocol UserInviteCustomCellDelegate {
  func didTapOnInvitee(tag: Int)
  func didTapOnViewGame(tag: Int)
}

class UserInviteCustomCell: UITableViewCell {
  
  @IBOutlet weak var userProfileImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var inviteStatus: UILabel!
  @IBOutlet weak var viewGameButton: UIButton!
  
  var delegate: UserInviteCustomCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    viewGameButton.layer.borderColor = UIColor.lightGray.cgColor
    //TapGesture recognizers
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnPlayerAssets))
    self.userProfileImage.addGestureRecognizer(tapGesture)
    self.userName.addGestureRecognizer(tapGesture)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  //MARK:- Setters Getters
  func setFriendUserName (name : String){
    userName.text = name
  }
  
  func setFriendUserImage (image : String){
    if let url = URL(string: image) {
      Nuke.loadImage(with: url, into: self.userProfileImage)
    }
  }
  
  func setFriendInviteStatus (status : String) {
    inviteStatus.text = status
  }
  
  func didTapOnPlayerAssets() {
    if let d = delegate {
      d.didTapOnInvitee(tag: self.tag)
    }
  }

  
  //MARK:- IBActions
  @IBAction func viewGameButtonPressed(_ sender: AnyObject) {
    if let d = delegate {
      d.didTapOnViewGame(tag: self.tag)
    }
  }
}
