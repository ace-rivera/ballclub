//
//  MapsViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  var locationList = [Location]()
  let locationManager = CLLocationManager()
  var isCenteredToCurrentLocation = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Ace Rivera : testing segue
//    let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.goToLocationDetail))
//    locationTapGesture.numberOfTapsRequired = 1
//    mapView.isUserInteractionEnabled = true
//    mapView.addGestureRecognizer(locationTapGesture)
    
    self.locationManager.requestAlwaysAuthorization()
    self.locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
    }
    
    self.getAllLocations()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.isCenteredToCurrentLocation = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - SetupUI
  func centerMapOnLocation(_ location: CLLocation) {
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                              regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  
    let currentPosition = LocationAnnotation(coordinate: location.coordinate, title: "MY HOME")
    self.mapView.addAnnotation(currentPosition)
  }
  
  @IBAction func didTapOnCreateGame(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Game", bundle: Bundle.main)
    if let createGameVC = storyboard.instantiateViewController(withIdentifier: "CreateGameViewController")
      as? CreateGameViewController {
      self.navigationController?.pushViewController(createGameVC, animated: true)
    }
  }
  func getAllLocations() {
    let locationViewModel = LocationViewModel()
    locationViewModel.getLocations { (statusCode, messsage, locations) -> (Void) in
      if let l = locations {
        self.locationList = l
        self.pinLocationsToMap()
      }
    }
  }
  
  func pinLocationsToMap() {
    if self.locationList.count > 0 {
      for location in self.locationList {
        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude!)!,
                                                 longitude: CLLocationDegrees(location.longitude!)!)
        let locationAnnotation = LocationAnnotation(coordinate: coordinates, title: location.locationName!)
        self.mapView.addAnnotation(locationAnnotation)
      }
    }
  }
  
  // MARK: - Navigation
  func goToLocationDetail() {
    self.performSegue(withIdentifier: "map_detail_segue", sender: self)
  }
}

extension MapsViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if let annotation = annotation as? LocationAnnotation {
      let identifier = "pin"
      var view: MKAnnotationView
      if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) { // 2
        dequeuedView.annotation = annotation
        view = dequeuedView
      } else {
        // 3
        view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
      }
      
      view.image = UIImage(named: "ic_pin")
      view.frame.size = CGSize(width: 45, height: 45)
      return view
    }
    return nil
  }
}

extension MapsViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let l = manager.location, !isCenteredToCurrentLocation {
      isCenteredToCurrentLocation = true
      let locValue: CLLocationCoordinate2D = l.coordinate
      let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
      centerMapOnLocation(initialLocation)
    }
  }
}
