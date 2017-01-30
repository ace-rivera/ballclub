//
//  ContainerViewController.swift
//  BallClub
//
//  Created by Don Joseph Rivera on 16/01/2017.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContainerViewController: UIViewController {
  
  private var loginViewController: LoginNavigationViewController?
  private var mainViewController: MainViewController?
  
  /* https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html
   *
   */
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // main tab bar controller
    self.initTabBarMainController()
    
    // login page
    self.initLoginViewController()
    
    // checking the session
    let isTokenExpired = SessionManager.sharedInstance.isTokenExpired()
    if SessionManager.sharedInstance.getSessionToken() != nil && !isTokenExpired {
      self.addChildViewController(self.mainViewController!)
      self.view.addSubview((self.mainViewController?.view)!)
    } else {
      self.addChildViewController(self.loginViewController!)
      self.view.addSubview((self.loginViewController?.view)!)
    }
    
    Utilities.getUsersList()
    self.setupNotifications()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.Notifications.didLoginNotification), object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.Notifications.didLogoutNotification), object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: Helper Functions
  func transition(fromViewController:UIViewController, toViewController:UIViewController) {
    fromViewController.willMove(toParentViewController: nil)
    self.addChildViewController(toViewController)
    
    self.transition(from: fromViewController, to: toViewController, duration: 0.25, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> (Void) in
    }, completion: {(success) -> (Void) in
      fromViewController.removeFromParentViewController()
      toViewController.didMove(toParentViewController: self)
    })
  }
  
  func didLogin(notification:Notification) {
    UserDefaults.standard.set(Date(), forKey: "loginTime")
    self.transition(fromViewController: self.loginViewController!, toViewController: self.mainViewController!)
  }
  
  func didLogout(notification:Notification) {
    self.transition(fromViewController: self.mainViewController!, toViewController: self.loginViewController!)
    
    //reset main tab view controller
    self.mainViewController = nil
    self.initTabBarMainController()
    
  }
  
  private func setupNotifications() {
    // setting up Notifications
    NotificationCenter.default.addObserver(self, selector: #selector(didLogin), name: NSNotification.Name(rawValue: Constants.Notifications.didLoginNotification), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: NSNotification.Name(rawValue: Constants.Notifications.didLogoutNotification), object: nil)
  }
  
  private func initLoginViewController() {
    let loginStoryboard = UIStoryboard(name: "Login", bundle: Bundle.main)
    self.loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as? LoginNavigationViewController
    self.loginViewController?.view.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func initTabBarMainController() {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    self.mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
    self.mainViewController?.view.translatesAutoresizingMaskIntoConstraints = false
  }
  
}
