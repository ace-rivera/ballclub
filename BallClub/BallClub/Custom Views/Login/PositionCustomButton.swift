//
//  PositionCustomButton.swift
//  BallClub
//
//  Created by Geraldine Forto on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class PositionCustomButton: UIButton {
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.backgroundColor = UIColor.clear
    self.titleLabel?.textColor = UIColor.lightGray
    self.layer.cornerRadius = self.frame.size.height/2.0
  }
  
  override var isSelected: Bool {
    willSet(newValue) {
      super.isSelected = newValue;
      if newValue == true{
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = Constants.CustomColor.customOrangeColor
        self.titleLabel?.textColor = UIColor.white
      }else{
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = UIColor.clear
        self.titleLabel?.textColor = UIColor.lightGray
      }
    }
  }
  
  
}
