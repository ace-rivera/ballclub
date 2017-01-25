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
  var firstName: String
  var lastName: String
  var nickName: String?
  var contactNumber: String?
  var city: String
  var height: Float?
  var weight: Float?
  var birthday: String?
  var gender: Int
  var avatar: String?
  var favoriteTeam: String?
  var favoritePlayer: String?
  var position: String?
  var games: [Game]?
  var friendRequests: [Request]?
  
  // MARK: - Deserialization
  init?(json: JSON) {
    guard let userId: Int = "id" <~~ json,
      let uid: String = "uid" <~~ json,
      let email: String = "email" <~~ json,
      let firstName: String = "first_name" <~~ json,
      let lastName: String = "last_name" <~~ json,
      let city: String = "city" <~~ json,
      let gender: Int = "gender" <~~ json else { return nil }
    
    self.playerId = userId
    self.uid = uid
    self.emailAddress = email
    self.firstName = firstName
    self.lastName = lastName
    self.nickName = "nickname" <~~ json
    self.contactNumber = "contact_number" <~~ json
    self.city = city
    self.height = "height" <~~ json
    self.weight = "weight" <~~ json
    self.birthday = "birthday" <~~ json
    self.avatar = "avatar" <~~ json
    self.gender = gender
    self.favoriteTeam = "favorite_team" <~~ json
    self.favoritePlayer = "favorite_player" <~~ json
    self.position = "position" <~~ json
    self.games = "games" <~~ json
    self.friendRequests = "friend_requests" <~~ json

  }
  
  static func toDictionary(user: Player) -> [String: Any] {
    var userDetails = [String:Any]()
    userDetails["id"] = user.playerId
    userDetails["uid"] = user.uid
    userDetails["email"] = user.emailAddress
    userDetails["first_name"] = user.firstName
    userDetails["last_name"] = user.lastName
    userDetails["city"] = user.city
    userDetails["nickname"] = user.nickName
    userDetails["contact_number"] = user.contactNumber
    userDetails["height"] = user.height
    userDetails["weight"] = user.weight
    userDetails["birthday"] = user.birthday
    userDetails["gender"] = user.gender
    userDetails["avatar"] = user.avatar
    userDetails["favorite_team"] = user.favoriteTeam
    userDetails["favorite_player"] = user.favoritePlayer
    userDetails["position"] = user.position
    
    return userDetails
  }
  
}
