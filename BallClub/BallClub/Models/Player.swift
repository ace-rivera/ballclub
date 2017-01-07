//
//  Player.swift
//  BallClub
//
//  Created by Ace Rivera on 07/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import Gloss

struct Player : Decodable {
  
  var playerId: Int
  var uid: String
  var emailAddress: String
  var playerName: String
  var nickName: String?
  var contactNumber: String?
  var city: String
  var height: Double?
  var weight: Double?
  var birthday: String?
  var gender: Int
  // TO-DO Get data when objects are finalized
  //var games: [Game]
  //var friendRequests: [Requests]
  
  // MARK: - Deserialization
  init?(json: JSON) {
    guard let userId: Int = "id" <~~ json,
      let uid: String = "uid" <~~ json,
      let email: String = "email" <~~ json,
      let name: String = "name" <~~ json,
      let city: String = "city" <~~ json,
      let gender: Int = "gender" <~~ json else { return nil }
    
    self.playerId = userId
    self.uid = uid
    self.emailAddress = email
    self.playerName = name
    self.nickName = "nickname" <~~ json
    self.contactNumber = "contact_number" <~~ json
    self.city = city
    self.height = "height" <~~ json
    self.weight = "weight" <~~ json
    self.birthday = "birthday" <~~ json
    self.gender = gender

  }
}
