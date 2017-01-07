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
  var reserved: Bool
  var minCapacity: Int
  var maxCapacity: Int
  var fee: Double?
  var additionalInfo: String?
//  var gameCreator: User
//  var location: Location

  // MARK: - Deserialization
  init?(json: JSON) {
    guard let gameId: Int = "id" <~~ json,
      let title: String = "title" <~~ json,
      let startTime: String = "start_time" <~~ json,
      let endTime: String = "end_time" <~~ json,
      let reserved: Bool = "reserved" <~~ json,
      let minCapacity: Int = "min_capacity" <~~ json,
      let maxCapacity: Int = "max_capacity" <~~ json,
      let fee: Double = "fee" <~~ json else { return nil }
//      let gameCreator: Int = "user" <~~ json,
//      let location: Int = "location" <~~ json else { return nil }
    
    self.gameId = gameId
    self.title = title
    self.startTime = startTime
    self.endTime = endTime
    self.reserved = reserved
    self.minCapacity = minCapacity
    self.maxCapacity = maxCapacity
    self.fee = fee
//    self.gameCreator = gameCreator
//    self.location = location
    self.additionalInfo = "additional_info" <~~ json
    
  }
}
