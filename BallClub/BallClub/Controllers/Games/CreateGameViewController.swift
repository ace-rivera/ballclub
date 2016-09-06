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
    self.createGameTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.createGameTableView.bounds.size.width, height: 0.01)) //remove header - extra space above tableview
  }
  
  //MARK: - IBAction
  @IBAction func doneButtonPressed(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func backButtonPressed(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
}
