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
    Utilities.showProgressHud(withTitle: "Retrieving Games", inView: self.view)
    //setup map

    if let longitude = Double(loc.longitude ?? ""),
      let latitude = Double(loc.latitude ?? "") {
      let span = MKCoordinateSpanMake(0.005, 0.005)
      let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      
      let region = MKCoordinateRegion(center: locationCoordinate, span: span)
      self.mapView.setRegion(region, animated: true)
      
      let currentPosition = LocationAnnotation(coordinate: locationCoordinate, title: loc.locationName ?? "")
      self.mapView.addAnnotation(currentPosition)
    }
    
    //setup location details
    self.locationName.text = loc.locationName ?? ""
    
    //setup game cells
    let gamesViewModel = GamesViewModel()
    if let id = loc.locationId {
      gamesViewModel.getGames(withLocationId: id) { (statusCode, mssage, games) -> (Void) in
        if statusCode == 200, let games = games {
          self.gameList = games
          //still needs to be edited
          let gamesThisWeek = games.count > 1 ? "GAMES THIS WEEK" : "GAME THIS WEEK"
          self.locationGames.text = "\(games.count) \(gamesThisWeek)"
          self.mapDetailTableView.reloadData()
          Utilities.hideProgressHud()
        }
      }
    }
  }
  
  @IBAction func closeButtonPressed(_ sender: AnyObject) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func filterButtonPressed(_ sender: AnyObject) {
    
  }
  
  @IBAction func backButtonPressed(_ sender: Any) {
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
      return cell
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.gameList.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let storyboard = UIStoryboard(name: "Game", bundle: Bundle.main)
    if let gameDetailVC = storyboard.instantiateViewController(withIdentifier: "gameDetailsVC")
      as? GameDetailViewController {
      if indexPath.row < self.gameList.count,
        let currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any] {
        let game = self.gameList[indexPath.row]
        gameDetailVC.gameCreatorId = game.gameCreator.playerId
        gameDetailVC.gameId = game.gameId
        
        let userId = currentUser["id"] as? Int ?? -1
        gameDetailVC.isCurrentUsersGame = game.gameCreator.playerId == userId
        self.navigationController?.pushViewController(gameDetailVC, animated: true)
      }
    }
  }
}
