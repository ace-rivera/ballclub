//
//  GameDetailViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: - IBAction
  @IBAction func backButtonPressed(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func seeAllButtonPressed(sender: AnyObject) {
    self.performSegueWithIdentifier("DetailToInvitedSegue", sender: self)
  }

}
