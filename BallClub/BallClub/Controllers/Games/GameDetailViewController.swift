//
//  GameDetailViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 06/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {
  @IBAction func seeAllButtonPressed(sender: AnyObject) {
    self.performSegueWithIdentifier("DetailToInvitedSegue", sender: self)
  }

}
