//
//  MainViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 31/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.hidden = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}
