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
  var userGamesList = [Game]()
  var publicGamesList = [Game]()
  var completedGamesList = [Game]()
  
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
          self.sortGamesList()
          Utilities.hideProgressHud()
        }
      }
    }
  }
  
  func sortGamesList() {
    if let currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any], let userId = currentUser["id"] as? Int {
      for game in self.gameList {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let endDate = dateFormatter.date(from: game.endTime) {
          if Date() > endDate {
            self.completedGamesList.append(game)
          } else {
            if game.gameCreator.playerId != userId &&
              game.privacy == 0 {
              self.publicGamesList.append(game)
            } else {
              self.userGamesList.append(game)
            }
          }
        }
      }
    }
    self.mapDetailTableView.reloadData()
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
      
      switch indexPath.section {
      case 0:
        cell.game = self.publicGamesList[indexPath.row]
      case 1:
        cell.game = self.userGamesList[indexPath.row]
      case 2:
        cell.game = self.completedGamesList[indexPath.row]
      default:
        cell.game = self.publicGamesList[indexPath.row]
      }
      
      self.view.layoutIfNeeded()
      return cell
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      //Ace Rivera : temp - use section 0 first
      return self.publicGamesList.count
    case 1:
      return self.userGamesList.count
    case 2:
      return self.completedGamesList.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GamesCategoryHeaderView") as! GamesCategoryHeaderView
    switch section {
    case 0:
      header.category = "PUBLIC"
    case 1:
      header.category = "MY GAMES"
    default:
      header.category = "COMPLETED"
    }
    
    header.updateUI()
    return header
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
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
