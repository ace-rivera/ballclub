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
//    self.layer.cornerRadius = self.frame.size.height/2
    self.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.backgroundColor = UIColor.clearColor()
    self.titleLabel?.textColor = UIColor.lightGrayColor()
  }
  
  override var selected: Bool {
    willSet(newValue) {
      super.selected = newValue;
      if newValue == true{
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.backgroundColor = Constants.CustomColor.customOrangeColor
        self.titleLabel?.textColor = UIColor.whiteColor()
      }else{
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.backgroundColor = UIColor.clearColor()
        self.titleLabel?.textColor = UIColor.lightGrayColor()
      }
    }
  }
  
  
}