//
//  Player.swift
//  BallClub
//
//  Created by Ace Rivera on 07/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import Foundation

class Player: NSObject {
  
  var playerId: String!
  var firstName: String!
  var lastName: String!
  var avatarImage: String!
  var heightFeet: Int!
  var heightInches: Float!
  var weight: Float!
  var birthdate: AnyObject!
  var gender: Constants.Gender!
  var position: Constants.Position!
  var hometown: Location!
  var favoritePlayer: String!
  var favoriteTeam: String!
  var playerInformation: String!
  
  init(dict: NSDictionary) {
    super.init()
    self.playerId = (dict["playerId"] ?? "") as! String
    self.firstName = (dict["firstName"] ?? "") as! String
    self.lastName = (dict["lastName"] ?? "") as! String
    self.avatarImage = (dict["avatarImage"] ?? "") as! String
    self.heightFeet = (dict["heightFeet"] ?? 0) as! Int
    self.heightInches = (dict["heightInches"] ?? 0) as! Float
    self.weight = (dict["weight"] ?? 0) as! Float
    self.birthdate = dict["birthdate"] ?? ""
    self.gender = dict["gender"] as! Constants.Gender
    self.position = dict["position"]as! Constants.Position
    self.hometown = dict["hometown"] as! Location
    self.favoritePlayer = (dict["favoritePlayer"] ?? "") as! String
    self.favoriteTeam = (dict["favoriteTeam"] ?? "") as! String
    self.playerInformation = (dict["playerInformation"] ?? "") as! String
    
  }
}
