//
//  Request.swift
//  BallClub
//
//  Created by Joshua Relova on 1/8/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import Gloss

struct Request : Decodable {
  
  var requestId: Int
  var userId: Int
  var friendId: Int
  var createdAt: String?
  var updatedAt: String?

  
  // MARK: - Deserialization
  init?(json: JSON) {
    guard let requestId: Int = "id" <~~ json,
      let userId: Int = "user_id" <~~ json,
      let friendId: Int = "friend_id" <~~ json else { return nil }
    

    self.requestId = requestId
    self.userId = userId
    self.friendId = friendId
    self.createdAt = "created_at" <~~ json
    self.updatedAt = "updated_at" <~~ json
  }
}
