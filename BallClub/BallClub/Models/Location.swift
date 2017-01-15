//
//  Location.swift
//  BallClub
//
//  Created by Ace Rivera on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import MapKit

import Gloss

struct Location : Decodable {
  
  var locationId: Int
  var latitude: Double
  var longitude: Double
  
  
  // MARK: - Deserialization
  init?(json: JSON) {
    guard let locationId: Int = "id" <~~ json,
      let latitude: Double = "latitude" <~~ json,
      let longitude: Double = "longitude" <~~ json else { return nil }
    
    self.locationId = locationId
    self.latitude = latitude
    self.longitude = longitude
  }
}
