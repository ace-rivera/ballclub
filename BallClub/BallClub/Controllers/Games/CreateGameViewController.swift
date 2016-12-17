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
    self.friendsCollectionView.register(UINib(nibName: "FriendsRoundedCollectionCell",bundle: nil), forCellWithReuseIdentifier: "FriendsRoundedCollectionCell")
    self.createGameTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width:
      self.createGameTableView.bounds.size.width, height: 0.01)) //remove header - extra space above tableview
    publicIcon.isSelected = false
    publicButton.isSelected = false
  }
  
  //MARK: - IBAction
  @IBAction func doneButtonPressed(_ sender: AnyObject) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func backButtonPressed(_ sender: AnyObject) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func seeAllButtonPressed(_ sender: AnyObject) {
    
    
  }
  
  @IBAction func setGamePrivacy(_ button: UIButton) {
    publicIcon.isSelected = false
    publicButton.isSelected = false
    privateIcon.isSelected = false
    privateButton.isSelected = false
    publicIcon.isSelected = false
    publicButton.isSelected = false
    
    switch button.tag {
    case 0:
      publicIcon.isSelected = true
      publicButton.isSelected = true
    case 1:
      privateIcon.isSelected = true
      privateIcon.isSelected = true
    case 2:
      closedIcon.isSelected = true
      closedButton.isSelected = true
    default:
      break
    }
    
  }
  
  @IBAction func reservedToggle(_ sender: AnyObject) {
    
  }
  
  @IBAction func approvalToggle(_ sender: AnyObject) {
  
  }

  //MARK: - Collection View Delegate
  private func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
    let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsRoundedCollectionCell", for: indexPath as IndexPath) as! FriendsRoundedCollectionCell
    collectionCell.setImageOfFriend(imageName: TestClass.Common.friendImages[indexPath.row])
    return collectionCell
  }
  
  private func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TestClass.Common.friendImages.count
  }
}
