//
//  FriendsRoundedCollectionCell.swift
//  BallClub
//
//  Created by Geraldine Forto on 09/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class FriendsRoundedCollectionCell: UICollectionViewCell {
  
  @IBOutlet weak var friendsImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setImageOfFriend(imageName : String) {
    friendsImage.image = UIImage(named: imageName)
  }
  
}
