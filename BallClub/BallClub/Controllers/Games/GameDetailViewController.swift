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
  @IBOutlet weak var notGoingIcon: UIButton!
  @IBOutlet weak var notGoingButton: UIButton!
  @IBOutlet weak var tentativeIcon: UIButton!
  @IBOutlet weak var tentativeButton: UIButton!
  @IBOutlet weak var goingIcon: UIButton!
  @IBOutlet weak var goingButton: UIButton!
  
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
    self.playerCollection.register(UINib(nibName: "FriendsRoundedCollectionCell",bundle: nil), forCellWithReuseIdentifier: "FriendsRoundedCollectionCell")
    self.gameDetailTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.gameDetailTableView.bounds.size.width, height: 0.01)) //remove header - extra space above tableview
    self.gameDetailTableView.estimatedRowHeight = 200
    self.gameDetailTableView.rowHeight = UITableViewAutomaticDimension
    additionInfo.sizeToFit()
  }
  
  //MARK: - IBAction
  @IBAction func backButtonPressed(sender: AnyObject) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func seeAllButtonPressed(sender: AnyObject) {
    self.performSegue(withIdentifier: "DetailToInvitedSegue", sender: self)
  }
  
  @IBAction func responseStatusButtonPressed(button: UIButton) {
    notGoingIcon.isSelected = false
    notGoingButton.isSelected = false
    tentativeIcon.isSelected = false
    tentativeButton.isSelected = false
    goingIcon.isSelected = false
    goingButton.isSelected = false
    
    switch button.tag {
    case 0:
      notGoingIcon.isSelected = true
      notGoingButton.isSelected = true
    case 1:
      tentativeIcon.isSelected = true
      tentativeButton.isSelected = true
    case 2:
      goingIcon.isSelected = true
      goingButton.isSelected = true
    default:
      break
    }
    
  }
  
  @IBAction func suggestInviteButtonPressed(sender: AnyObject) {
    
  }
  
  //MARK: - Collection View Delegate
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsRoundedCollectionCell", for: indexPath as IndexPath) as! FriendsRoundedCollectionCell
    collectionCell.setImageOfFriend(imageName: TestClass.Common.friendImages[indexPath.row])
    return collectionCell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TestClass.Common.friendImages.count
  }
}
