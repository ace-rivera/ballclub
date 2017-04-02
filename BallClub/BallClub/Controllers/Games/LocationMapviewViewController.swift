//
//  LocationMapviewViewController.swift
//  BallClub
//
//  Created by Don Joseph Rivera on 02/04/2017.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import MapKit

protocol LocationMapViewDelegate {
  func locationSelected(location: Location)
}

class LocationMapviewViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  var locationList = [Location]()
  let locationManager = CLLocationManager()
  var isCenteredToCurrentLocation = false
  var selectedLocation: Location?
  
  var delegate: LocationMapViewDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.locationManager.requestAlwaysAuthorization()
    self.locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.isCenteredToCurrentLocation = false
    self.getAllLocations()
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
    locationViewModel.getLocations { (statusCode, message, locations) -> (Void) in
      if statusCode == 200, let locations = locations {
        self.locationList = locations
      } else {
        if let m = message {
          self.showAlert(title: "Error", message: m, callback: {})
        }
      }
    }
  }
  
  func pinLocationsToMap() {
    if self.locationList.count > 0 {
      for location in self.locationList {
        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude!)!,
                                                 longitude: CLLocationDegrees(location.longitude!)!)
        let locationAnnotation = LocationAnnotation(coordinate: coordinates, title: location.locationName!)
        if let tag = location.tag {
          locationAnnotation.tag = tag
        }
        self.mapView.addAnnotation(locationAnnotation)
      }
    }
  }
}

extension LocationMapviewViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if let annotation = annotation as? LocationAnnotation {
      let identifier = "pin"
      var view: MKAnnotationView
      if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) { // 2
        dequeuedView.annotation = annotation
        view = dequeuedView
        if let tag = annotation.tag {
          view.tag = tag
        }
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
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if view.tag < self.locationList.count {
      if let navVc = self.navigationController, let d = self.delegate {
        d.locationSelected(location: self.locationList[view.tag])
        navVc.popViewController(animated: true)
      }
    }
  }
}

extension LocationMapviewViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let l = manager.location, !isCenteredToCurrentLocation {
      isCenteredToCurrentLocation = true
      let locValue: CLLocationCoordinate2D = l.coordinate
      let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
      centerMapOnLocation(initialLocation)
    }
  }
}
