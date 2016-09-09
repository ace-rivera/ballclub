//
//  Location.swift
//  BallClub
//
//  Created by Ace Rivera on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import MapKit

class Location: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let annotationImageName: String
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, annotationImageName: String) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.annotationImageName = annotationImageName
        
        super.init()
    }
}