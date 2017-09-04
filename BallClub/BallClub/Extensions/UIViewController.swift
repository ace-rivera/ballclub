//
//  UIViewController.swift
//  BallClub
//
//  Created by Joshua Relova on 12/17/16.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

extension UIViewController: StoryboardIdentifiable {}

extension UIViewController {
  
  /**
   AlertController helper factory
   
   - parameter title: Title of alert
   - parameter message: Message of alert
   - parameter callback: Callback of alert "Ok"
   
   - returns: UIAlertController
   */
  
  func showAlert(title: String, message: String, callback: @escaping () -> ()) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
      alertAction in
      callback()
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  func showAlertWithDefaultButtons(title: String, message: String, callback: @escaping () -> ()) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
      alertAction in
      callback()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  
}
