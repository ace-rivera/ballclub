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
  
  var gameList = [Game]()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.getGames()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func getGames() {
    let gameViewModel = GamesViewModel()
    gameViewModel.getCurrentUserGames { (statusCode, message, games) -> (Void) in
      if statusCode == 200, let games = games {
        self.gameList = games
        self.gamesTableview.reloadData()
      }
    }
  }
  
  //MARK: - SetUpUI
  func setUpUI() {
    //TODO: autoresize cell study!!
//    self.gamesTableview.estimatedRowHeight = 150.0
//    self.gamesTableview.rowHeight = UITableViewAutomaticDimension
    self.gamesTableview.register(UINib(nibName: "GamesCategoryHeaderView",bundle: nil), forHeaderFooterViewReuseIdentifier: "GamesCategoryHeaderView")
    self.gamesTableview.register(UINib(nibName: "FeedsCustomCell",bundle: nil), forCellReuseIdentifier: "FeedsCustomCell")
    self.gamesTableview.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.gamesTableview.bounds.size.width, height: 0.01)) //remove header - extra space above tableview
  }
}


extension GamesViewController : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCustomCell") as? FeedsCustomCell {
      cell.game = self.gameList[indexPath.row]
      return cell
    }
    return UITableViewCell()
  }
  
  private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3 // closed public private
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      //Ace Rivera : temp - use section 0 first
      return self.gameList.count
    case 1:
      return 0
    case 2:
      return 0
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "GameDetailSegue", sender: self)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GamesCategoryHeaderView") as! GamesCategoryHeaderView
    switch section {
    case 0:
      header.category = "CLOSED"
    case 1:
      header.category = "PUBLIC"
    case 2:
      header.category = "PRIVATE"
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
