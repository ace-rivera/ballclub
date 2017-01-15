//
//  Game.swift
//  BallClub
//
//  Created by Ace Rivera on 07/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import Gloss

struct Game : Decodable {

  var gameId: Int
  var title: String
  var startTime: String
  var endTime: String
  var reserved: Bool?
  var minCapacity: Int?
  var maxCapacity: Int?
  var fee: Double
  var privacy: Int
  var additionalInfo: String?
  var gameCreator: Player
//  var location: Location

  // MARK: - Deserialization
  init?(json: JSON) {
    guard let gameId: Int = "id" <~~ json,
      let title: String = "title" <~~ json,
      let startTime: String = "start_time" <~~ json,
      let endTime: String = "end_time" <~~ json,
      let fee: Double = "fee" <~~ json,
      let privacy: Int = "privacy" <~~ json,
      let gameCreator: Player = "user" <~~ json  else { return nil }
//      let location: Location = "location" <~~ json else { return nil }
    
    self.gameId = gameId
    self.title = title
    self.startTime = startTime
    self.endTime = endTime
    self.minCapacity = "min_capacity" <~~ json
    self.maxCapacity = "max_capacity" <~~ json
    self.fee = fee
    self.privacy = privacy
    self.gameCreator = gameCreator
//    self.location = location
    self.reserved = "reserved" <~~ json
    self.additionalInfo = "additional_info" <~~ json
    
  }
}
