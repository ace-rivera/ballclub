//
//  CustomColor.swift
//  BallClub
//
//  Created by Geraldine Forto on 05/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class Constants: NSObject {
  
  //customColor
  struct CustomColor {
    static let tabBarBackgroundColor = UIColor(red: 36/255.0, green: 37/255.0, blue: 32/255.0, alpha: 1)
    static let customOrangeColor = UIColor(red: 224/255.0, green: 96/255.0, blue: 36/255.0, alpha: 1)
    static let customGreenColor = UIColor(red: 94/255.0, green: 219/255.0, blue: 32/255.0, alpha: 1)
    static let customBlueColor = UIColor(red: 14/255.0, green: 99/255.0, blue: 236/255.0, alpha: 1)
  }
    
  enum Category {
    case PUBLIC
    case PRIVATE
    case CLOSED
  }
  
  enum Position {
    case C
    case G
    case F
  }
  
  enum Gender {
    case Male
    case Female
  }
}
