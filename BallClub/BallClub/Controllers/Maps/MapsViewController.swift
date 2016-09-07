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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Ace Rivera : testing segue
        let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.goToLocationDetail))
        locationTapGesture.numberOfTapsRequired = 1
        mapView.userInteractionEnabled = true
        mapView.addGestureRecognizer(locationTapGesture)
        self.setupUI()
    }
    
    // MARK: - SetupUI
    func setupUI() {
        let initialLocation = CLLocation(latitude: 14.6760, longitude: 121.0437)
        centerMapOnLocation(initialLocation)
        
        let sampleAnnotation = LocationAnnotation(title: "Quezon City",
                                                  locationName: "Quezon City",
                                                  discipline: "City",
                                                  coordinate: CLLocationCoordinate2D(latitude: 14.6760, longitude: 121.0437),
                                                  annotationImageName: "ic_pin")
        
        mapView.addAnnotation(sampleAnnotation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - Navigation
    func goToLocationDetail() {
        self.performSegueWithIdentifier("map_detail_segue", sender: self)
    }
}

extension MapsViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? LocationAnnotation {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            if let pinImage = UIImage(named: annotation.annotationImageName) {
                view.image = pinImage
                view.frame.size = CGSizeMake(45, 45)
            }
            return view
        }
        return nil
    }
}