//
//  GamesViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController {
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: - IBAction
  @IBAction func testButtonPressed(sender: AnyObject) {
    self.performSegueWithIdentifier("GameDetailSegue", sender: self)
  }
}
