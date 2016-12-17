//
//  Utilities.swift
//  BallClub
//
//  Created by Joshua Relova on 12/17/16.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import SwiftyJSON

struct Utilities {
  
  static var loadingHud = MBProgressHUD()
  
  
  static func showProgressHud(withTitle title: String, inView view: UIView) {
    self.loadingHud.bezelView.color = UIColor.green // Your backgroundcolor
    self.loadingHud.bezelView.style = .solidColor
    self.loadingHud.mode = MBProgressHUDMode.indeterminate
    self.loadingHud.label.text = title
    self.loadingHud = MBProgressHUD.showAdded(to: view, animated: true)
  }
  
  static func showMessageHUD(withTitle title: String, inView view: UIView, callback: @escaping () -> ()) {
    self.loadingHud.mode = MBProgressHUDMode.text
    self.loadingHud.label.text = title
    self.loadingHud = MBProgressHUD.showAdded(to: view, animated: true)
    self.loadingHud.hide(animated: true, afterDelay: 2.0)
  }
  
  static func hideProgressHud() {
    self.loadingHud.hide(animated: true)
  }
}
