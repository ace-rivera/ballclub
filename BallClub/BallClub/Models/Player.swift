//
//  Player.swift
//  BallClub
//
//  Created by Ace Rivera on 07/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import Foundation

enum Position {
    case C
    case G
    case F
}

enum Gender {
    case Male
    case Female
}

class Player: NSObject {

    var firstName: String!
    var lastName: String!
    var avatarImage: String!
    var heightFeet: Int!
    var heightInches: Float!
    var weight: Float!
    var birthdate: AnyObject!
    var gender: Gender!
    var position: Position!
    var hometown: Location!
    var favoritePlayer: String!
    var favoriteTeam: String!
    var playerInformation: String!

    init(dict: NSDictionary) {
        super.init()
        self.firstName = (dict["firstName"] ?? "") as! String
        self.lastName = (dict["lastName"] ?? "") as! String
        self.avatarImage = (dict["avatarImage"] ?? "") as! String
        self.heightFeet = (dict["heightFeet"] ?? 0) as! Int
        self.heightInches = (dict["heightInches"] ?? 0) as! Float
        self.weight = (dict["weight"] ?? 0) as! Float
        self.birthdate = dict["birthdate"] ?? ""
        self.gender = dict["gender"] as! Gender
        self.position = dict["position"]as! Position
        self.hometown = dict["hometown"] as! Location
        self.favoritePlayer = (dict["favoritePlayer"] ?? "") as! String
        self.favoriteTeam = (dict["favoriteTeam"] ?? "") as! String
        self.playerInformation = (dict["playerInformation"] ?? "") as! String

    }
}
