//
//  LocationListViewController.swift
//  BallClub
//
//  Created by Don Joseph Rivera on 16/01/2017.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit

protocol LocationListViewControllerDelegate {
  func showSelectedLocation(location: Location)
}

class LocationListViewController : UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  var locationList = [Location]()
  var delegate : LocationListViewControllerDelegate?
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.getLocationList()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.locationList = [Location]()
  }
  
  //MARK: - Helper Methods
  func getLocationList() {
    let locationViewModel = LocationViewModel()
    locationViewModel.getLocations { (status, message, locations) -> (Void) in
      if status == Constants.ResponseCodes.STATUS_OK,
        let locations = locations {
        self.locationList = locations
        self.tableView.reloadData()
      } else {
        self.showAlert(title: "Error", message: "Unable to fetch locations.", callback: {})
      }
    }
  }
}

extension LocationListViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //filter here
    let filteredArray = self.locationList.filter{ $0.locationName == searchText }
    self.locationList = filteredArray
    self.tableView.reloadData()
  }
}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
  //MARK: - TableView Delegates
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locationList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellIdentifier"),
      let label = cell.textLabel {
      label.text = self.locationList[indexPath.row].locationName
      return cell
    } else {
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let d = delegate {
      d.showSelectedLocation(location: locationList[indexPath.row])
      self.navigationController?.popViewController(animated: true)
    }
  }
}
