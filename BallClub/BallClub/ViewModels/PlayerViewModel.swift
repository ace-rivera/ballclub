//
//  PlayerViewModel.swift
//  BallClub
//
//  Created by Joshua Relova on 12/17/16.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import SwiftyJSON
import Gloss

class PlayerViewModel: NSObject {
  
  public typealias UserSignInResponseClosure = (Bool, String?) -> (Void)
  public typealias GetAllUserResponseClosure = (Bool, String, [Player]?) -> (Void)
  public typealias GetCurrentUserResponseClosure = (Bool, String, Player?) -> (Void)
  var allUsersArray = [Player]()
  var currentUser: Player?
  
  func playerSign(emailAddress: String, password: String, completionBlock: (UserSignInResponseClosure)? = nil) {
    APIProvider.request(.userSignIn(emailAddress, password)) { (result) in
      switch result {
      case .success(let response):
        do {
          let data = try response.mapJSON()
          debugPrint("data ", data)
          
          if let datadict = data as? NSDictionary {
            if let error = datadict.object(forKey: "errors") as? NSArray {
              completionBlock!(false, error[0] as? String)
            } else {
              let userDetail = datadict.object(forKey: "data") as? [String:Any]
              
              if let playerDictionary = userDetail, let p = Player(json: playerDictionary) {
                self.currentUser = p
                completionBlock!(true,"Success")
              } else {
                completionBlock!(false, "Error")
              }
            }
            
          }
          
        } catch {
          completionBlock!(false, "Error")
        }
      case .failure(let error):
        completionBlock!(false, error.localizedDescription)
      }
    }
  }
  
  func getAllUsers(completionBlock: (GetAllUserResponseClosure)? = nil) {
    APIProvider.request(.getAllUsers()) { (result) in
      switch result {
      case .success(let response):
        do {
          let data = try response.mapJSON()
          debugPrint("data ", data)
          
          if let dataDict = data as? NSArray {
//            if let error = datadict.object(forKey: "errors") as? NSArray {
//              completionBlock!(false, error[0] as? String)
//            } else {
            
              for player in dataDict {
                if let playerDictionary = player as? [String:Any], let p = Player(json:playerDictionary) {
                  self.allUsersArray.append(p)
                }
              }
              
              if self.allUsersArray.count > 0 {
                completionBlock!(true,"Success",self.allUsersArray)
              } else {
                completionBlock!(false, "Error", nil)
              }
           // }
            
          }
          
        } catch {
          completionBlock!(false, "Error", nil)
        }
      case .failure(let error):
        completionBlock!(false, error.localizedDescription, nil)
      }
    }
  }
  
  func getUser(userId: Int, completionBlock: (GetCurrentUserResponseClosure)? = nil ) {
    APIProvider.request(.getCurrentUser(userId)) { (result) in
      switch result {
      case .success(let response):
        do {
          let data = try response.mapJSON()
          debugPrint("data ", data)
          
          if let playerDictionary = data as? [String: Any] {
            if let error = playerDictionary["errors"] as? NSArray, let errorMessage = error[0] as? String {
              completionBlock!(false, errorMessage, nil)
            } else {
              if let p = Player(json: playerDictionary){
                completionBlock!(true, "User retrieved successfully", p)
              } else {
                completionBlock!(false, "Cannot convert to Player object", nil)
              }
            }
            
          }
          
        } catch {
          completionBlock!(false, "Error", nil)
        }
      case .failure(let error):
        completionBlock!(false, error.localizedDescription, nil)
      }
    }
  }
  
  
}
