//
//  LocationSearchTable.swift
//  BallClub
//
//  Created by Ace Rivera on 25/01/2017.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
  
  var matchingItems:[MKMapItem] = []
  var mapView: MKMapView? = nil
  var delegate: CreateLocationViewControllerDelegate? = nil
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func parseAddress(selectedItem:MKPlacemark) -> String {
    
    let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
    
    let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
    
    let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
    let addressLine = String(
      format:"%@%@%@%@%@%@%@",
      // street number
      selectedItem.subThoroughfare ?? "",
      firstSpace,
      // street name
      selectedItem.thoroughfare ?? "",
      comma,
      // city
      selectedItem.locality ?? "",
      secondSpace,
      // state
      selectedItem.administrativeArea ?? ""
    )
    return addressLine
  }
}

extension LocationSearchTable: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let mapView = self.mapView,
      let searchBarText = searchController.searchBar.text else { return }
    
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = searchBarText
    request.region = mapView.region
    let search = MKLocalSearch(request: request)
    search.start { response, _ in
      guard let response = response else {
        return
      }
      self.matchingItems = response.mapItems
      self.tableView.reloadData()
    }
  }
}

extension LocationSearchTable {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return matchingItems.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
      let selectedItem = matchingItems[indexPath.row].placemark
      cell.textLabel?.text = selectedItem.name
      cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedItem = matchingItems[indexPath.row].placemark
    if let d = self.delegate {
      d.dropPinZoomIn(placemark: selectedItem)
      dismiss(animated: true, completion: nil)
    }
  }
}
