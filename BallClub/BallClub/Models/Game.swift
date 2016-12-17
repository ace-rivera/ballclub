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
  var gameOwner: Player!
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
    self.gameOwner = (dict["gameOwner"] ?? 0) as! Player
    self.gameTitle = (dict["gameTitle"] ?? "") as! String
    self.gameDescription = (dict["gameDescription"] ?? "") as! String
    self.gameLocation = (dict["gameLocation"] ?? 0) as! Location
    self.startDate = dict["startDate"] ?? ""
    self.endDate = dict["endDate"] ?? ""
    self.maxPlayers = (dict["maxPlayers"] ?? 0) as! Int
    self.invitedPlayers = (dict["invitedPlayers"] ?? [:]) as! NSDictionary
    self.fee = (dict["fee"] ?? 0) as! Double
    self.isReserverd = (dict["isReserverd"] ?? false) as! Bool
    self.isApprovalRequired = (dict["isApprovalRequired"] ?? false) as! Bool
    
  }
  
  //MARK: - Getters and Setters
  func getId() -> String {
    return self.gameId
  }
  
  func getGameOwner() -> Player {
    return self.gameOwner
  }
  
  func getGameTitle() -> String {
    return self.gameTitle
  }
  
  func getGameDescription() -> String {
    return self.gameDescription
  }
  
  func getGameLocation() -> Location {
    return self.gameLocation
  }
  
  func getStartDate() -> NSDate {
    return self.startDate as! NSDate
  }
  
  func getEndDate() -> NSDate {
    return self.endDate as! NSDate
  }
  
  func getMaxPlayers() -> Int {
    return self.maxPlayers
  }
  
  func getInvitedPlayers() -> NSDictionary {
    return self.invitedPlayers
  }
  
  func getPendingPlayers() -> NSDictionary {
    let pendingPlayers = [:]
    for (key,value) in self.invitedPlayers {
      if (value as! Constants.InviteStatus) == Constants.InviteStatus.PENDING {
        pendingPlayers.setValue(value, forKey: key as! String)
      }
    }
    return pendingPlayers
  }
  
  func getNotGoingPlayers() -> NSDictionary {
    let notGoingPlayers = [:]
    for (key,value) in self.invitedPlayers {
      if (value as! Constants.InviteStatus) == Constants.InviteStatus.NOT_GOING {
        notGoingPlayers.setValue(value, forKey: key as! String)
      }
    }
    return notGoingPlayers
  }
  
  func getGoingPlayers() -> NSDictionary {
    let goingPlayers = [:]
    for (key,value) in self.invitedPlayers {
      if (value as! Constants.InviteStatus) == Constants.InviteStatus.GOING {
        goingPlayers.setValue(value, forKey: key as! String)
      }
    }
    return goingPlayers
  }
}