//
//  SingleMapViewController.swift
//  BallClub
//
//  Created by Don Joseph Rivera on 06/06/2017.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import MapKit

class SingleMapViewController : UIViewController {
  
  var latitude: Double = 0.0
  var longitude: Double = 0.0
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupMapView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func backButtonPressed(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  func setupMapView() {
    
    let coordinates = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    let mkAnnotation = LocationAnnotation(coordinate: coordinates, title: "")
    
    self.mapView.addAnnotation(mkAnnotation)
    let span = MKCoordinateSpanMake(0.005, 0.005)
    let region = MKCoordinateRegion(center: mkAnnotation.coordinate, span: span)
    self.mapView.setRegion(region, animated: true)
  }
  
}
