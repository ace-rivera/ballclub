//
//  GamesViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class GamesViewController: UIViewController {
  
  @IBOutlet weak var gamesTableview: UITableView!
  
  @IBOutlet weak var currentWeekTitle: UIBarButtonItem!
  var userGamesList = [Game]()
  var publicGamesList = [Game]()
  var closedGamesList = [Game]()
  var completedGamesList = [Game]()
  
  var filteredPublicGames = [Game]()
  var filteredUserGames = [Game]()
  var filteredCompletedGames = [Game]()
  
  var isSearchEnabled = false
  var selectedGameId: Int?
  var gameCreatorId: Int?
  var isCurrentUsersGame = false
  var currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any]
  var selectedIndexPath : IndexPath!
  var currentDate: String!
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
   
    let week = NSCalendar.current.component(.weekOfYear, from: Date())
    let year = NSCalendar.current.component(.year, from: Date())

    self.currentDate = "\(year)\(week)"
//    self.getGamesFromYearWeek(yearWeek: self.currentDate)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.getGames()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    Utilities.hideProgressHud()
    self.resetData()
    self.isSearchEnabled = false
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
  
  //ACE : PUBLIC GAMES
  //MARK: - Helper Methods
  func getGames() {
    self.resetData()
    Utilities.showProgressHud(withTitle: "Fetching Avaliable Games", inView: self.view)
    let gameViewModel = GamesViewModel()
    if let currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any], let userId = currentUser["id"] as? Int {
//      gameViewModel.getCurrentUserGames(userId: userId) { (statusCode, message, games) -> (Void) in
//        if statusCode == 200, let games = games {
//          self.userGamesList = games
//          self.gamesTableview.reloadData()
          //start
          gameViewModel.getAllGames { (statusCode2, mssage2, games2) -> (Void) in
            if statusCode2 == 200, let games2 = games2 {
              let dateFormatter = DateFormatter()
              dateFormatter.locale = Locale(identifier: "en_US_POSIX")
              dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
              dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
              for game in games2 {
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
//              let publicGames = games2.filter {
//                $0.gameCreator.playerId != userId &&
//                  $0.privacy == 0 //how to know if closed
//              }
//              self.publicGamesList = publicGames
              self.gamesTableview.reloadData()
              Utilities.hideProgressHud()
            } else {
              Utilities.hideProgressHud()
              self.showAlert(title: "Error", message: "Unable to fetch games", callback: {})
            }
          }
          
          if (self.publicGamesList.count == 0 && self.userGamesList.count == 0) {
            self.initializeDelegates()
          }
          //end
//        } else {
//          Utilities.hideProgressHud()
//          self.showAlert(title: "Error", message: "Unable to fetch games", callback: {})
//        }
//      }
    }
  }
  
//  func getGamesFromYearWeek(yearWeek: String) {
//    Utilities.showProgressHud(withTitle: "Fetching Avaliable Games", inView: self.view)
//    let gameViewModel = GamesViewModel()
//    if let currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any], let userId = currentUser["id"] as? Int {
//      gameViewModel.getCurrentUserGames(fromYearWeek: yearWeek, userId: userId, completionBlock: { (statusCode, message, games) -> (Void) in
//        if statusCode == 200, let games = games {
//          self.userGamesList = games
//          for game in games {
//            switch game.privacy {
//            case 0:
//              self.publicGamesList.append(game)
//            case 1:
//              self.closedGamesList.append(game)
//            default:
//              self.publicGamesList.append(game)
//            }
//          }
//          
//          if (self.publicGamesList.count == 0 && self.closedGamesList.count == 0) {
//                self.initializeDelegates()
//          }
//            
//          self.gamesTableview.reloadData()
//          Utilities.hideProgressHud()
//        } else {
//          Utilities.hideProgressHud()
//          self.showAlert(title: "Error", message: "Unable to fetch games", callback: {})
//        }
//      })
//    }
//  }
  
  func resetData() {
    self.userGamesList = [Game]()
    self.publicGamesList = [Game]()
    self.closedGamesList = [Game]()
    self.completedGamesList = [Game]()
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
  
  @IBAction func didTapOnPreviousWeek(_ sender: Any) {
    self.resetData()
    let currDate = Int(self.currentDate) ?? 0
    self.currentDate = "\(currDate-1)"
//    self.getGamesFromYearWeek(yearWeek: self.currentDate)
  }
  
  @IBAction func didTapOnNextWeek(_ sender: Any) {
    self.resetData()
    let currDate = Int(self.currentDate) ?? 0
    self.currentDate = "\(currDate+1)"
//    self.getGamesFromYearWeek(yearWeek: self.currentDate)
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
      
      switch indexPath.section {
      case 0:
        if self.isSearchEnabled {
          cell.game = self.filteredPublicGames[indexPath.row]
        } else {
          cell.game = self.publicGamesList[indexPath.row]
        }
      case 1:
        if self.isSearchEnabled {
          cell.game = self.filteredUserGames[indexPath.row]
        } else {
          cell.game = self.userGamesList[indexPath.row]
        }
      case 2:
        if self.isSearchEnabled {
          cell.game = self.filteredCompletedGames[indexPath.row]
        } else {
          cell.game = self.completedGamesList[indexPath.row]
        }
      default:
        if self.isSearchEnabled {
          cell.game = self.filteredPublicGames[indexPath.row]
        } else {
          cell.game = self.publicGamesList[indexPath.row]
        }
      }
      
      self.view.layoutIfNeeded()
      return cell
    }
    return UITableViewCell()
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3 //public, my games, completed
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      if self.isSearchEnabled {
        return self.filteredPublicGames.count
      } else {
        return self.publicGamesList.count
      }
    case 1:
      if self.isSearchEnabled {
        return self.filteredUserGames.count
      } else {
        return self.userGamesList.count
      }
    case 2:
      if self.isSearchEnabled {
        return self.filteredCompletedGames.count
      } else {
        return self.completedGamesList.count
      }
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell : FeedsCustomCell = tableView.cellForRow(at: indexPath) as! FeedsCustomCell
    if self.isSearchEnabled {
      if cell.detailsShown || indexPath.section != 0 { //2nd click
        cell.detailsShown = false
        selectedIndexPath = nil
        if indexPath.section == 0 {
          if self.filteredPublicGames[indexPath.row].gameCreator.playerId == currentUser?["id"] as? Int {
            isCurrentUsersGame = true
          } else {
            isCurrentUsersGame = false
          }
          self.gameCreatorId = self.filteredPublicGames[indexPath.row].gameCreator.playerId
          self.selectedGameId = self.filteredPublicGames[indexPath.row].gameId
          self.performSegue(withIdentifier: "GameDetailSegue", sender: self)
        } else if indexPath.section == 1 {
          if self.filteredUserGames[indexPath.row].gameCreator.playerId == currentUser?["id"] as? Int {
            isCurrentUsersGame = true
          } else {
            isCurrentUsersGame = false
          }
          self.gameCreatorId = self.filteredUserGames[indexPath.row].gameCreator.playerId
          self.selectedGameId = self.filteredUserGames[indexPath.row].gameId
          self.performSegue(withIdentifier: "GameDetailSegue", sender: self)
        } else if indexPath.section == 2 {
          if self.filteredCompletedGames[indexPath.row].gameCreator.playerId == currentUser?["id"] as? Int {
            isCurrentUsersGame = true
          } else {
            isCurrentUsersGame = false
          }
          self.gameCreatorId = self.filteredCompletedGames[indexPath.row].gameCreator.playerId
          self.selectedGameId = self.filteredCompletedGames[indexPath.row].gameId
          self.performSegue(withIdentifier: "GameDetailSegue", sender: self)
        }
      } else { //expand
        cell.detailsShown = true
        selectedIndexPath = indexPath
        tableView.reloadData()
      }
    } else {
      if cell.detailsShown || indexPath.section != 0 { //2nd click
        cell.detailsShown = false
        selectedIndexPath = nil
        if indexPath.section == 0 {
          if self.publicGamesList[indexPath.row].gameCreator.playerId == currentUser?["id"] as? Int {
            isCurrentUsersGame = true
          } else {
            isCurrentUsersGame = false
          }
          self.gameCreatorId = self.publicGamesList[indexPath.row].gameCreator.playerId
          self.selectedGameId = self.publicGamesList[indexPath.row].gameId
          self.performSegue(withIdentifier: "GameDetailSegue", sender: self)
        } else if indexPath.section == 1 {
          if self.userGamesList[indexPath.row].gameCreator.playerId == currentUser?["id"] as? Int {
            isCurrentUsersGame = true
          } else {
            isCurrentUsersGame = false
          }
          self.gameCreatorId = self.userGamesList[indexPath.row].gameCreator.playerId
          self.selectedGameId = self.userGamesList[indexPath.row].gameId
          self.performSegue(withIdentifier: "GameDetailSegue", sender: self)
        } else if indexPath.section == 2 {
          if self.completedGamesList[indexPath.row].gameCreator.playerId == currentUser?["id"] as? Int {
            isCurrentUsersGame = true
          } else {
            isCurrentUsersGame = false
          }
          self.gameCreatorId = self.completedGamesList[indexPath.row].gameCreator.playerId
          self.selectedGameId = self.completedGamesList[indexPath.row].gameId
          self.performSegue(withIdentifier: "GameDetailSegue", sender: self)
        }
      } else { //expand
        cell.detailsShown = true
        selectedIndexPath = indexPath
        tableView.reloadData()
      }
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
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
}

extension GamesViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func initializeDelegates() {
        self.gamesTableview.emptyDataSetSource = self
        self.gamesTableview.emptyDataSetDelegate = self
    }
    
    
    // MARK: UI for empty data
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named:"noNotifs")
//    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "There are no games for this week!"
        let myAttribute = [ NSForegroundColorAttributeName: UIColor.darkGray, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0) ]
        let myAttrString = NSAttributedString(string: title, attributes: myAttribute)
        
        
        
        return myAttrString
    }
}

extension GamesViewController : UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print("\(searchText)")
    if searchText.characters.count > 0 {
      self.isSearchEnabled = true
    } else {
      self.isSearchEnabled = false
    }
    
    if self.isSearchEnabled {
      let publicGames = self.publicGamesList.filter {
        $0.title.lowercased().contains(searchText.lowercased()) ||
          $0.gameCreator.lastName.lowercased().contains(searchText.lowercased()) ||
          $0.gameCreator.firstName.lowercased().contains(searchText.lowercased())
      }
      self.filteredPublicGames = publicGames
      
      let userGames = self.userGamesList.filter {
        $0.title.lowercased().contains(searchText.lowercased()) ||
          $0.gameCreator.lastName.lowercased().contains(searchText.lowercased()) ||
          $0.gameCreator.firstName.lowercased().contains(searchText.lowercased())
      }
      self.filteredUserGames = userGames
      
      let completedGames = self.completedGamesList.filter {
        $0.title.lowercased().contains(searchText.lowercased()) ||
          $0.gameCreator.lastName.lowercased().contains(searchText.lowercased()) ||
          $0.gameCreator.firstName.lowercased().contains(searchText.lowercased())
      }
      self.filteredCompletedGames = completedGames
    }
    self.gamesTableview.reloadData()
    
  }
}
