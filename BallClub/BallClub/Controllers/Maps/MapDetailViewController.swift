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
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.mapDetailTableView.register(UINib(nibName: "FeedsCustomCell",bundle: nil), forCellReuseIdentifier: "FeedsCustomCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        
    }
  
    @IBAction func filterButtonPressed(sender: AnyObject) {
        
    }
}

extension MapDetailViewController: UITableViewDelegate,UITableViewDataSource {
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
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return TestClass.Feeds.FeedTitle.count
    default:
      return 0
    }
  }
  
  //TODO: code didselect
//  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    self.performSegueWithIdentifier("GameDetailSegue", sender: self)
//  }

}
