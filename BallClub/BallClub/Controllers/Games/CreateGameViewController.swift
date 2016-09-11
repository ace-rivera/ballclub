//
//  CreateGameViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class CreateGameViewController: UITableViewController,UICollectionViewDelegate {
  
  @IBOutlet var createGameTableView: UITableView!
  @IBOutlet weak var gameTitleTextField: UITextField!
  @IBOutlet weak var friendsCollectionView: UICollectionView!
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var startTimeButton: UIButton!
  @IBOutlet weak var endTimeButton: UIButton!
  @IBOutlet weak var playerCount: UITextField!
  @IBOutlet weak var feeTextField: UITextField!
  @IBOutlet weak var infoTextfield: UITextField!
  @IBOutlet weak var publicIcon: UIButton!
  @IBOutlet weak var publicButton: UIButton!
  @IBOutlet weak var privateIcon: UIButton!
  @IBOutlet weak var privateButton: UIButton!
  @IBOutlet weak var closedIcon: UIButton!
  @IBOutlet weak var closedButton: UIButton!
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: - SetupUI
  func setUpUI(){
    self.friendsCollectionView.registerNib(UINib(nibName: "FriendsRoundedCollectionCell",bundle: nil), forCellWithReuseIdentifier: "FriendsRoundedCollectionCell")
    self.createGameTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width:
      self.createGameTableView.bounds.size.width, height: 0.01)) //remove header - extra space above tableview
    publicIcon.selected = false
    publicButton.selected = false
  }
  
  //MARK: - IBAction
  @IBAction func doneButtonPressed(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func backButtonPressed(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func seeAllButtonPressed(sender: AnyObject) {
    
    
  }
  
  @IBAction func setGamePrivacy(button: UIButton) {
    publicIcon.selected = false
    publicButton.selected = false
    privateIcon.selected = false
    privateButton.selected = false
    publicIcon.selected = false
    publicButton.selected = false
    
    switch button.tag {
    case 0:
      publicIcon.selected = true
      publicButton.selected = true
    case 1:
      privateIcon.selected = true
      privateIcon.selected = true
    case 2:
      closedIcon.selected = true
      closedButton.selected = true
    default:
      break
    }
    
  }
  
  @IBAction func reservedToggle(sender: AnyObject) {
    
  }
  
  @IBAction func approvalToggle(sender: AnyObject) {
  
  }

  //MARK: - Collection View Delegate
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("FriendsRoundedCollectionCell", forIndexPath: indexPath) as! FriendsRoundedCollectionCell
    collectionCell.setImageOfFriend(TestClass.Common.friendImages[indexPath.row])
    return collectionCell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TestClass.Common.friendImages.count
  }
}
