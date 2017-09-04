//
//  FriendsRoundedCollectionCell.swift
//  BallClub
//
//  Created by Geraldine Forto on 09/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import Nuke

class FriendsRoundedCollectionCell: UICollectionViewCell {
  
  @IBOutlet weak var friendsImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setImageOfFriend(imageUrlString : String) {
    if let imageUrl = URL(string: imageUrlString) {
      Nuke.loadImage(with: imageUrl, into: friendsImage)
    }
  }
  
}
