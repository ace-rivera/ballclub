//
//  GameDetailViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class GameDetailViewController: UITableViewController {
  
  @IBOutlet var gameDetailTableView: UITableView!
  
  @IBOutlet weak var locationImage: UIImageView!
  @IBOutlet weak var gameDate: UILabel!
  @IBOutlet weak var gameTitle: UILabel!
  @IBOutlet weak var gameLocation: UILabel!
  @IBOutlet weak var gamePrice: UILabel!
  @IBOutlet weak var gameTime: UILabel!
  @IBOutlet weak var gameDetails: UILabel!
  @IBOutlet weak var playerCount: UILabel!
  @IBOutlet weak var playerNames: UILabel!
  @IBOutlet weak var playerCollection: UICollectionView!
  @IBOutlet weak var additionInfo: UILabel!
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: - SetUpUI
  func setUpUI(){
    self.gameDetailTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.gameDetailTableView.bounds.size.width, height: 0.01)) //remove header - extra space above tableview
  }
  
  //MARK: - IBAction
  @IBAction func backButtonPressed(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func seeAllButtonPressed(sender: AnyObject) {
    self.performSegueWithIdentifier("DetailToInvitedSegue", sender: self)
  }
  
  @IBAction func notGoingPressed(sender: AnyObject) {
    
  }
  
  @IBAction func tentativeButtonPressed(sender: AnyObject) {
    
  }
  
  @IBAction func goingButtonPressed(sender: AnyObject) {
    
  }
  
  @IBAction func suggestInviteButtonPressed(sender: AnyObject) {
    
  }
}
