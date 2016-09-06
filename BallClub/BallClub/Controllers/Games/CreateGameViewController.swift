//
//  CreateGameViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class CreateGameViewController: UITableViewController {
  
  @IBOutlet var createGameTableView: UITableView!
  
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
    self.createGameTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: 0.01))
  }
  
  //MARK: - IBAction
  @IBAction func doneButtonPressed(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
}
