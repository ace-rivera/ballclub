//
//  Game.swift
//  BallClub
//
//  Created by Ace Rivera on 07/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import Foundation

class Game: NSObject {
    
  var gameId: String!
  var gameTitle: String!
  var gameDescription: String!
  var gameLocation: Location!
  var startDate: AnyObject!
  var endDate: AnyObject!
  var maxPlayers: Int!
  var invitedPlayers: NSDictionary!
  var fee: Double!
  var isReserverd: Bool!
  var isApprovalRequired: Bool!
  
  init(dict: NSDictionary) {
    super.init()
    self.gameId = (dict["gameId"] ?? "") as! String
    self.gameTitle = (dict["gameTitle"] ?? "") as! String
    self.gameDescription = (dict["gameDescription"] ?? "") as! String
    self.gameLocation = (dict["gameLocation"] ?? 0) as! Location
    //self.startDate = dict["startDate"] ?? ""
    //self.endDate = dict["endDate"] ?? ""
    self.maxPlayers = (dict["maxPlayers"] ?? 0) as! Int
    self.invitedPlayers = (dict["invitedPlayers"] ?? [:]) as! NSDictionary
    self.fee = (dict["fee"] ?? 0) as! Double
    self.isReserverd = (dict["isReserverd"] ?? false) as! Bool
    self.isApprovalRequired = (dict["isApprovalRequired"] ?? false) as! Bool
    
  }
}
