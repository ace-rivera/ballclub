//
//  CustomColor.swift
//  BallClub
//
//  Created by Geraldine Forto on 05/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class Constants: NSObject {
  
  
  static let kSimpleEmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
  static let kLessSimpleEmailRegex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
  static let clientId = "5cebe071636f1dbd9b3d08b18fb01a29791299f9ab35b38c43306496c5c7c9f1"
  static let clientSecret = "6640bb30dd952bdfcc43a94df588791e306e9ba386502ce27d47708cb260b3c9"
  static let grantType = "client_credentials"
  
  //customColor
  struct CustomColor {
    static let tabBarBackgroundColor = UIColor(red: 36/255.0, green: 37/255.0, blue: 32/255.0, alpha: 1)
    static let customOrangeColor = UIColor(red: 224/255.0, green: 96/255.0, blue: 36/255.0, alpha: 1)
    static let customGreenColor = UIColor(red: 94/255.0, green: 219/255.0, blue: 32/255.0, alpha: 1)
    static let customBlueColor = UIColor(red: 14/255.0, green: 99/255.0, blue: 236/255.0, alpha: 1)
  }
  
  struct ResponseCodes {
    static let STATUS_OK = 200
    static let STATUS_CREATED = 201
    static let STATUS_NO_CONTENT = 204
    static let STATUS_MISSING_PARAMETERS = 422
  }
  
  enum Notifications {
    static let didLoginNotification           = "DidLoginNotification"
    static let didLogoutNotification          = "DidLogoutNotification"
  }

  enum Category {
    case PUBLIC
    case PRIVATE
    case CLOSED
  }
  
  enum InviteStatus {
    case PENDING
    case GOING
    case NOT_GOING
  }
  
  enum Position {
    case C
    case G
    case F
  }
  
  enum Gender {
    case MALE
    case FEMALE
  }
}
