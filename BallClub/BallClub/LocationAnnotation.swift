//
//  LocationAnnotation.swift
//  BallClub
//
//  Created by Ace Rivera on 30/01/2017.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import MapKit

class LocationAnnotation : NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var tag: Int?
  
  init(coordinate: CLLocationCoordinate2D, title: String) {
    self.coordinate = coordinate
    self.title = title
  }
}
