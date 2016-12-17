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
  var playerName: String?
  var emailAddress: String
  var provider: String?
  var uid: String?
  var nickName: String?
  var profileImage: String?
  var contactNumber: String?
  var city: String?
  var height: String?
  var weight: String?
  var birthday: String?
  var gender: String?
  
  // MARK: - Deserialization
  init?(json: JSON) {
    guard let userId: Int = "id" <~~ json,
      let email: String = "email" <~~ json else { return nil }
    
    self.playerId = userId
    self.playerName = "name" <~~ json
    self.emailAddress = email
    self.provider = "provider" <~~ json
    self.uid = "uid" <~~ json
    self.nickName = "nickname" <~~ json
    self.profileImage = "image" <~~ json
    self.contactNumber = "contact_number" <~~ json
    self.city = "city" <~~ json
    self.height = "height" <~~ json
    self.weight = "weight" <~~ json
    self.birthday = "birthday" <~~ json
    self.gender = "gender" <~~ json

  }
}
