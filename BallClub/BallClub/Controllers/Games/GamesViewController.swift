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
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.gamesTableview.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCustomCell") as! FeedsCustomCell
    cell.setDateOfGame(date: NSDate())
    cell.setTitleOfGame(title: TestClass.Feeds.FeedTitle[indexPath.row])
    cell.setCreatorOfGame(name: TestClass.Feeds.FeedCreator[indexPath.row])
    cell.setLocationOfGame(location: TestClass.Feeds.FeedLocation[indexPath.row])
    cell.setTimeOfGame(startTime: TestClass.Feeds.FeedStartTime[indexPath.row], endTime: TestClass.Feeds.FeedEndTime[indexPath.row], amPm: TestClass.Feeds.FeedAmPm[indexPath.row])
    cell.setPriceOfGame(price: TestClass.Feeds.FeedPrice[indexPath.row])
    cell.setMemberCountOfGame(count: TestClass.Feeds.FeedFriends[indexPath.row].count, maxCount: 10)
    cell.setAttendeesOfGame(friends: TestClass.Feeds.FeedFriends[indexPath.row])
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3 // closed public private
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 3
    case 1:
      return 1
    case 2:
      return 2
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.performSegue(withIdentifier: "GameDetailSegue", sender: self)
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
}
