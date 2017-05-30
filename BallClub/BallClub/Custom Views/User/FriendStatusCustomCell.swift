//
//  FriendStatusCustomCell.swift
//  BallClub
//
//  Created by Geraldine Forto on 31/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import Nuke

protocol FriendStatusCustomCellDelegate {
  func didTapOnUser(tag: Int)
}

class FriendStatusCustomCell: UITableViewCell {
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userStatus: UIImageView!
  @IBOutlet weak var userPositionImageView: UIButton!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userCity: UILabel!
  
  var delegate: FriendStatusCustomCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnPlayer))
    self.userImageView.addGestureRecognizer(tapGesture)
    self.userName.addGestureRecognizer(tapGesture)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setFriendUserName (name : String){
    userName.text = name
  }
  
  func setFriendsPosition (position: String) {
    userPositionImageView.setTitle(position, for: .normal)
  }
  
  func setFriendUserImage (image : String){
    if let url = URL(string: image) {
      Nuke.loadImage(with: url, into: self.userImageView)
    }
  }
  
  func setuserCity (city : String) {
    userCity.text = city
  }
  
  func didTapOnPlayer() {
    if let d = delegate {
      d.didTapOnUser(tag: self.tag)
    }
  }
  
}
