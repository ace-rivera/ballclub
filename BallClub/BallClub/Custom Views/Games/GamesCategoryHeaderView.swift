//
//  GamesCategoryHeaderView.swift
//  BallClub
//
//  Created by Geraldine Forto on 07/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class GamesCategoryHeaderView: UITableViewHeaderFooterView {
  
  @IBOutlet weak var categoryImage: UIImageView!
  @IBOutlet weak var categoryFlag: UIImageView!
  @IBOutlet weak var categoryTitle: UILabel!
  var category : String! //TODO: create enum for this
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = UIColor.lightGray
  }
  
  func updateUI(){
    if category == "CLOSED" {
      categoryImage.image = UIImage(named: "ic_closed")
      categoryFlag.image = UIImage(named: "green")
    }else if category == "PRIVATE"{
      categoryImage.image = UIImage(named: "ic_private")
      categoryFlag.image = UIImage(named: "blue")
    }else{
      categoryImage.image = UIImage(named: "ic_public")
      categoryFlag.image = UIImage(named: "orange")
    }
    
    categoryTitle.text = category
  }
}
