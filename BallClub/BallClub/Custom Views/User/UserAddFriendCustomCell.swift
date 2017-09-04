//
//  UserAddFriendCustomCell.swift
//  BallClub
//
//  Created by Geraldine Forto on 31/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import Nuke

protocol UserAddFriendCustomCellDelegate {
  func didTapOnUser(tag: Int)
  func didTapOnAcceptFriend(tag: Int)
}

class UserAddFriendCustomCell: UITableViewCell {
  
  @IBOutlet weak var userProfileImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var acceptInvite: UIButton!
  @IBOutlet weak var declineInvite: UIButton!
  
  var delegate: UserAddFriendCustomCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
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
  
  func setFriendsPosition (position: String) {
    
  }
  
  func setFriendUserImage (image : String){
    if let url = URL(string: image) {
      Nuke.loadImage(with: url, into: self.userProfileImage)
    } 
  }
  
  func didTapOnPlayerAssets() {
    if let d = delegate {
      d.didTapOnUser(tag: self.tag)
    }
  }
  
  @IBAction func acceptFriend(_ sender: AnyObject) {
    if let d = delegate {
      d.didTapOnAcceptFriend(tag: self.tag)
    }
  }
  
  //MARK:- IBAction
  @IBAction func rejectFriend(_ sender: AnyObject) {
    
  }
}
