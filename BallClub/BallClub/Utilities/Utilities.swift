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
  static var allPlayersArray = [Player]()
  
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
  
  static func isValidEmail(email: String) -> Bool {
    let emailTest = NSPredicate(format:"SELF MATCHES %@", Constants.kLessSimpleEmailRegex)
    return emailTest.evaluate(with: email)
  }
  
  static func getUsersList() {
    let playerViewModel = PlayerViewModel()
    playerViewModel.getAllUsers { (responseCode, message, playersArray) -> (Void) in
      if (responseCode == 200 || responseCode == 201), let players = playersArray {
        self.allPlayersArray =  players
      }
    }
  }
  
  static func getGoingUsers(invites : [Invite]) -> [Player] {
    var goingPlayers = [Player]()
    
    for invite in invites {
      if invite.status == 2 {
        let filteredUser = self.allPlayersArray.filter {
          $0.playerId == invite.userId
        }
        if filteredUser.count > 0 {
          goingPlayers.append(filteredUser.first!)
        }
      }
    }
    
    return goingPlayers
  }
  
  static func getInvitedPlayers(invites : [Invite]) -> [Player] {
    var invitedPlayers = [Player]()
    self.getUsersList()
    for invite in invites {
      
      let filteredUser = self.allPlayersArray.filter {
        $0.playerId == invite.userId
      }
      if filteredUser.count > 0 {
        invitedPlayers.append(filteredUser.first!)
      }
    }
    return invitedPlayers
  }
}
