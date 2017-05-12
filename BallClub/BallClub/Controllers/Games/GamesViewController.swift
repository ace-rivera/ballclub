//
//  GamesViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController {
  
  @IBOutlet weak var gamesTableview: UITableView!
  
  var userGamesList = [Game]()
  var publicGamesList = [Game]()
  var selectedGameId: Int?
  var gameCreatorId: Int?
  var isCurrentUsersGame = false
  var currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any]
  var selectedIndexPath : IndexPath!
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.getGames()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    Utilities.hideProgressHud()
    self.gamesTableview.reloadData() //used to hide details of selected cell
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "GameDetailSegue" {
      if let gameDetailViewController: GameDetailViewController = segue.destination as? GameDetailViewController {
        if let gameId = self.selectedGameId, let playerId = self.gameCreatorId {
          gameDetailViewController.gameCreatorId = playerId
          gameDetailViewController.gameId = gameId
          gameDetailViewController.isCurrentUsersGame = isCurrentUsersGame
        }
      }
    }
  }
  
  
  //MARK: - Helper Methods
  func getGames() {
    Utilities.showProgressHud(withTitle: "Fetching Avaliable Games", inView: self.view)
    let gameViewModel = GamesViewModel()
    if let currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any], let userId = currentUser["id"] as? Int {
      gameViewModel.getCurrentUserGames(userId: userId) { (statusCode, message, games) -> (Void) in
        if statusCode == 200, let games = games {
          self.userGamesList = games
          self.gamesTableview.reloadData()
          //start
          gameViewModel.getAllGames { (statusCode2, mssage2, games2) -> (Void) in
            if statusCode2 == 200, let games2 = games2 {
              let publicGames = games2.filter {
                $0.gameCreator.playerId != userId &&
                  $0.privacy == 0 //how to know if closed
              }
              self.publicGamesList = publicGames
              self.gamesTableview.reloadData()
              Utilities.hideProgressHud()
            } else {
              Utilities.hideProgressHud()
              self.showAlert(title: "Error", message: "Unable to fetch games", callback: {})
            }
          }
          //end
        } else {
          Utilities.hideProgressHud()
          self.showAlert(title: "Error", message: "Unable to fetch games", callback: {})
        }
      }
    }
  }
  
  //MARK: - SetUpUI
  func setUpUI() {
    self.gamesTableview.register(UINib(nibName: "GamesCategoryHeaderView",bundle: nil), forHeaderFooterViewReuseIdentifier: "GamesCategoryHeaderView")
    self.gamesTableview.register(UINib(nibName: "FeedsCustomCell",bundle: nil), forCellReuseIdentifier: "FeedsCustomCell")
    self.gamesTableview.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.gamesTableview.bounds.size.width, height: 0.01)) //remove header - extra space above tableview
    //TODO: autoresize cell study!!
    self.gamesTableview.estimatedRowHeight = 150.0
    self.gamesTableview.rowHeight = UITableViewAutomaticDimension
  }
}


extension GamesViewController : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCustomCell") as? FeedsCustomCell {
      cell.detailsShown = false
      cell.detailView.isHidden = true
      cell.detailViewBottomLayout.constant = 20.0
      
      if let selected = selectedIndexPath {
        if (selected == indexPath && !cell.detailsShown) {
          cell.detailsShown = true
          cell.detailView.isHidden = false
          cell.detailViewBottomLayout.constant = 70.0
          self.view.layoutIfNeeded()
        }
      }
      
      if indexPath.section == 0 {
        cell.game = self.userGamesList[indexPath.row]
      } else {
        cell.game = self.publicGamesList[indexPath.row]
      }
      
      self.view.layoutIfNeeded()
      return cell
    }
    return UITableViewCell()
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2 //my games, public games
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      //Ace Rivera : temp - use section 0 first
      return self.userGamesList.count
    case 1:
      return self.publicGamesList.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell : FeedsCustomCell = tableView.cellForRow(at: indexPath) as! FeedsCustomCell
    if cell.detailsShown || indexPath.section == 0 { //2nd click
      cell.detailsShown = false
      selectedIndexPath = nil
      if indexPath.section == 0 {
        if self.userGamesList[indexPath.row].gameCreator.playerId == currentUser?["id"] as? Int {
          isCurrentUsersGame = true
        } else {
          isCurrentUsersGame = false
        }
        self.gameCreatorId = self.userGamesList[indexPath.row].gameCreator.playerId
        self.selectedGameId = self.userGamesList[indexPath.row].gameId
        self.performSegue(withIdentifier: "GameDetailSegue", sender: self)
      } else {
        if self.publicGamesList[indexPath.row].gameCreator.playerId == currentUser?["id"] as? Int {
          isCurrentUsersGame = true
        } else {
          isCurrentUsersGame = false
        }
        self.gameCreatorId = self.publicGamesList[indexPath.row].gameCreator.playerId
        self.selectedGameId = self.publicGamesList[indexPath.row].gameId
        self.performSegue(withIdentifier: "GameDetailSegue", sender: self)
      }
    } else { //expand
      cell.detailsShown = true
      selectedIndexPath = indexPath
      
      tableView.reloadData()
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GamesCategoryHeaderView") as! GamesCategoryHeaderView
    switch section {
    case 0:
      header.category = "MY GAMES"
    case 1:
      header.category = "PUBLIC GAMES"
    default:
      break
    }
    
    header.updateUI()
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
}
