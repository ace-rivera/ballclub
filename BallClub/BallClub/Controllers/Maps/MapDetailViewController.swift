//
//  MapDetailViewController.swift
//  BallClub
//
//  Created by Ace Rivera on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import MapKit

class MapDetailViewController: UIViewController {
  
  @IBOutlet weak var mapDetailTableView: UITableView!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var locationName: UILabel!
  @IBOutlet weak var locationGames: UILabel!
  
  var currentLocation: Location? {
    didSet {
      if let l = self.currentLocation {
        self.setupLocationGames(loc: l)
      }
    }
  }
  var gameList = [Game]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.mapDetailTableView.register(UINib(nibName: "FeedsCustomCell",bundle: nil), forCellReuseIdentifier: "FeedsCustomCell")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  private func setupLocationGames(loc: Location) {
    let gamesViewModel = GamesViewModel()
    if let id = loc.locationId {
      gamesViewModel.getGames(withLocationId: id) { (statusCode, mssage, games) -> (Void) in
        if statusCode == 200, let games = games {
          self.gameList = games
          self.mapDetailTableView.reloadData()
        }
      }
    }
  }
  
  @IBAction func closeButtonPressed(_ sender: AnyObject) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func filterButtonPressed(_ sender: AnyObject) {
    
  }
  
  func backButtonPressed(){
    _ = self.navigationController?.popViewController(animated: true)
  }
}

extension MapDetailViewController: UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCustomCell") as? FeedsCustomCell {
      cell.detailsShown = false
      cell.detailView.isHidden = true
      cell.detailViewBottomLayout.constant = 20.0
      
      cell.game = self.gameList[indexPath.row]
      
      self.view.layoutIfNeeded()
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.gameList.count
  }
  
  //TODO: code didselect
  //  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  //    self.performSegueWithIdentifier("GameDetailSegue", sender: self)
  //  }
  
}
