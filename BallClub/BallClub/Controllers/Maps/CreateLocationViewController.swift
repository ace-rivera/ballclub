//
//  CreateLocationViewController.swift
//  BallClub
//
//  Created by Ace Rivera on 25/01/2017.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import MapKit

protocol CreateLocationViewControllerDelegate {
  func dropPinZoomIn(placemark:MKPlacemark)
  func dismissViewControllerWithLocation(createdLocation: Location)
}

class CreateLocationViewController: UIViewController {
  
  @IBOutlet weak var searchView: UIView!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var locationNameTextField: UITextField!

  let locationManager = CLLocationManager()
  var resultSearchController: UISearchController? = nil
  var selectedPin:MKPlacemark? = nil
  var delegate : CreateLocationViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationItem.hidesBackButton = true
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
    
    //searchBar
    let storyBoard = UIStoryboard(name: "Maps", bundle: Bundle.main)
    if let locationSearchTable = storyBoard.instantiateViewController(withIdentifier: "LocationSearchTable") as? LocationSearchTable {
      resultSearchController = UISearchController(searchResultsController: locationSearchTable)
      resultSearchController?.searchResultsUpdater = locationSearchTable
      
      locationSearchTable.mapView = mapView
      locationSearchTable.delegate = self
    }
    
    if let searchBarController = self.resultSearchController {
      let searchBar = searchBarController.searchBar
      let searchBarFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40.0)
      
      searchBar.sizeToFit()
      searchBar.placeholder = "Type Location"
      searchBar.frame = searchBarFrame
      
      self.searchView.addSubview(searchBar)
      searchBarController.hidesNavigationBarDuringPresentation = true
      searchBarController.dimsBackgroundDuringPresentation = true
      definesPresentationContext = false
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func didTapOnCancel(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func didTapOnDone(_ sender: Any) {
    guard let locationName = self.locationNameTextField.text,
    locationName.characters.count > 0 else {
      self.showAlert(title: "Error", message: "Please enter location name.", callback: {})
      return
    }
    
    guard let selectedLocation = self.selectedPin else {
      self.showAlert(title: "Error", message: "Please select location.", callback: {})
      return
    }
    
    var locationDict = [String : Any]()
    locationDict["name"]      = locationName
    locationDict["longitude"] = selectedLocation.coordinate.longitude
    locationDict["latitude"]  = selectedLocation.coordinate.latitude
    
    let locationViewModel = LocationViewModel()
    
    locationViewModel.createLocation(locationDict: locationDict) { (statusCode, message, location) -> (Void) in
      if statusCode == Constants.ResponseCodes.STATUS_CREATED
        || statusCode == Constants.ResponseCodes.STATUS_OK {
        self.showAlert(title: "Success", message: "Location created successfully", callback: {
            
            if let d = self.delegate, let l = location {
                d.dismissViewControllerWithLocation(createdLocation: l)
            }
          
          self.navigationController?.popViewController(animated: true)
        })
      } else {
        self.showAlert(title: "Error", message: "Please check your internet connection and try again.", callback: { 
          return
        })
      }
    }
    
  }
}

extension CreateLocationViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status  == .authorizedWhenInUse {
      locationManager.requestLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      print("location -> \(location)")
      let span = MKCoordinateSpanMake(0.005, 0.005)
      let region = MKCoordinateRegion(center: location.coordinate, span: span)
      mapView.setRegion(region, animated: true)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error -> \(error)")
  }
}

extension CreateLocationViewController: CreateLocationViewControllerDelegate {
    func dismissViewControllerWithLocation(createdLocation: Location) {}

  func dropPinZoomIn(placemark:MKPlacemark){
    // cache the pin
    selectedPin = placemark
    // clear existing pins
    mapView.removeAnnotations(mapView.annotations)
    let annotation = MKPointAnnotation()
    annotation.coordinate = placemark.coordinate
    annotation.title = placemark.name
    if let city = placemark.locality,
      let state = placemark.administrativeArea {
      annotation.subtitle = "\(city), \(state)"
    }
    mapView.addAnnotation(annotation)
    let span = MKCoordinateSpanMake(0.005, 0.005)
    let region = MKCoordinateRegionMake(placemark.coordinate, span)
    mapView.setRegion(region, animated: true)
  }
}
