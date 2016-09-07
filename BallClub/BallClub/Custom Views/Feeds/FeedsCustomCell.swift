//
//  FeedsCustomCell.swift
//  BallClub
//
//  Created by Geraldine Forto on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class FeedsCustomCell: UITableViewCell {
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var gameTitle: UILabel!
  @IBOutlet weak var gameCreator: UILabel!
  
  @IBOutlet weak var gameLocation: UILabel!
  
  @IBOutlet weak var gameTime: UILabel!
  @IBOutlet weak var gamePrice: UILabel!
  
  @IBOutlet weak var gameMemberCount: UILabel!
  @IBOutlet weak var gameFriends: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
