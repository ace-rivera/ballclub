//
//  Invite.swift
//  BallClub
//
//  Created by Joshua Relova on 1/8/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import Gloss

struct Invite : Decodable {
  
  var inviteId: Int
  var userId: Int
  var gameId: Int
  var inviterId: Int
  var status: Int
  var membership: Int
  var createdAt: String?
  var updatedAt: String?
  
  // MARK: - Deserialization
  init?(json: JSON) {
    guard let inviteId: Int = "id" <~~ json,
      let userId: Int = "user_id" <~~ json,
      let gameId: Int = "game_id" <~~ json,
      let inviterId: Int = "inviter_id" <~~ json,
      let status: Int = "status" <~~ json,
      let membership: Int = "membership" <~~ json else { return nil }
    
    self.inviteId = inviteId
    self.userId = userId
    self.gameId = gameId
    self.inviterId = inviterId
    self.status = status
    self.membership = membership
    self.createdAt = "created_at" <~~ json
    self.updatedAt = "updated_at" <~~ json

  }
}
