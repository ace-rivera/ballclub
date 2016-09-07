//
//  TestClass.swift
//  BallClub
//
//  Created by Geraldine Forto on 02/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class TestClass: NSObject {
  
  struct Common {
    static let friendNames = ["Dhin Forto","Ace Rivera","Josh Relova","Erick Abutal","Chard Cordero","Rey Tugade","Lloyd Urbino"]
    static let friendImages = ["player_michaelJordan","player_shaq","player_kobe","player_terrence","player_calvin","player_curry","player_lebron"]
    static let friendLocations = ["Bulacan","Quezon City","Antipolo City","Cavite, too many to mention","Makati City","SM North Edsa","Paranaque City"]
    static let friendPositions = ["C","G","F","C","F","G","G"]
  }
  
  struct Login {
    
  }
  
  struct Game {
    static let goingFriends = ["Dhin Forto","Ace Rivera","Josh Relova","Erick Abutal","Chard Cordero","Rey Tugade","Lloyd Urbino"]
    static let tentativeFriends = ["Paula Javier", "Kyle Sy"]
    static let invitedFriends = ["Jomari Esguerra","Mariag Indrinal", "Miani DeVera"]
  }
  
  struct Maps {
    
  }
  
  struct User {
    var profileImage : NSString!
  }
  
  struct Feeds {
    static let FeedDates = ["SAT 4/21","MON 5/12","SUN 7/27"]
    static let FeedTitle = ["Basketball Clinic : Level 1", "Streetball Challenge", "Kuroko Contest"]
    static let FeedCreator = ["Dhin Forto", "Ace Rivera", "Josh Relova"]
    static let FeedLocation = ["Balagtas,Bulacan", "Eastwood City", "Japan"]
    static let FeedStartTime = ["8:00","4:00", "3:00"]
    static let FeedEndTime = ["12:00","7:00","9:00"]
    static let FeedAmPm = ["AM","PM","PM"]
    static let FeedPrice = ["70","none","none"]
    static let FeedFriends : [[String]] = [["Ace Rivera"],["Josh Relova","Erick Abutal","Chard Cordero"],[]]
  }
  
  struct Others {
    
  }
  
}
