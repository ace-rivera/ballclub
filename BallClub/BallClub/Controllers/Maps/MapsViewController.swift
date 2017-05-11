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
  var gameList = [Game]()
  let locationManager = CLLocationManager()
  var isCenteredToCurrentLocation = false
  var selectedLocation: Location?
  var initialLocation: CLLocation?
  
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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.getAllGameLocations()
    self.isCenteredToCurrentLocation = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - SetupUI
  func centerMapOnLocation(_ location: CLLocation) {
    let span = MKCoordinateSpanMake(0.005, 0.005)
    let region = MKCoordinateRegion(center: location.coordinate, span: span)
    
    mapView.setRegion(region, animated: true)
//    let currentPosition = LocationAnnotation(coordinate: location.coordinate, title: "MY HOME")
//    self.mapView.addAnnotation(currentPosition)
  }
  
  //ACE : change
  @IBAction func didTapOnCreateGame(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Maps", bundle: Bundle.main)
    if let createGameVC = storyboard.instantiateViewController(withIdentifier: "CreateLocationViewController")
      as? CreateLocationViewController {
      self.navigationController?.pushViewController(createGameVC, animated: true)
    }
  }
  
  @IBAction func didTapOnCurrentLocation(_ sender: Any) {
    self.isCenteredToCurrentLocation = false
    if let l = self.initialLocation {
      self.centerMapOnLocation(l)
    }
  }
  
  
  func getAllGameLocations() {
    let gameViewModel = GamesViewModel()
    gameViewModel.getAllGames { (statusCode, mssage, games) -> (Void) in
      if statusCode == 200, let games = games {
        self.gameList = games
        for index in 0..<games.count {
          var game = games[index]
          game.location.tag = index
          self.locationList.append(game.location)
          self.pinLocationsToMap()
        }
      } else {
        self.showAlert(title: "Error", message: "Unable to fetch games", callback: {})
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
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "map_detail_segue" {
      if let mapDetailVC: MapDetailViewController = segue.destination as? MapDetailViewController,
        let loc = self.selectedLocation {
        mapDetailVC.currentLocation = loc
      }
    }
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
      self.selectedLocation = self.locationList[view.tag]
      self.performSegue(withIdentifier: "map_detail_segue", sender: self)
    }
  }
}

extension MapsViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let l = manager.location, !isCenteredToCurrentLocation {
      isCenteredToCurrentLocation = true
      let locValue: CLLocationCoordinate2D = l.coordinate
      let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
      self.initialLocation = initialLocation
      centerMapOnLocation(initialLocation)
    }
  }
}
