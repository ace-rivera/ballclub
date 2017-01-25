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
  
  public typealias UpdateUserResponseClosure = (Int, String?) -> (Void)
  public typealias GetAllUserResponseClosure = (Int, String, [Player]?) -> (Void)
  public typealias GetCurrentUserResponseClosure = (Int, String, Player?) -> (Void)
  var allUsersArray = [Player]()

  func getAllUsers(completionBlock: (GetAllUserResponseClosure)? = nil) {
    allUsersArray = [Player]()
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
                completionBlock!(response.statusCode,"Success",self.allUsersArray)
              } else {
                completionBlock!(response.statusCode, "Error", nil)
              }
           // }
            
          }
          
        } catch {
          completionBlock!(response.statusCode, "Error", nil)
        }
      case .failure(let error):
        if let compBlock = completionBlock,
          let response = error.response {
        compBlock(response.statusCode, error.localizedDescription, nil)
        }
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
              completionBlock!(response.statusCode, errorMessage, nil)
            } else {
              if let p = Player(json: playerDictionary){
                completionBlock!(response.statusCode, "User retrieved successfully", p)
              } else {
                completionBlock!(response.statusCode, "Cannot convert to Player object", nil)
              }
            }
            
          }
          
        } catch {
          completionBlock!(response.statusCode, "Error", nil)
        }
      case .failure(let error):
        if let compBlock = completionBlock,
          let response = error.response {
        compBlock(response.statusCode, error.localizedDescription, nil)
        }
      }
    }
  }
  
  func updateUser(userId: Int, userCredentials: [String:Any], completionBlock: (UpdateUserResponseClosure)? = nil) {
    APIProvider.request(.updateUser(userId, userCredentials)) { (result) in
      switch result {
      case .success(let response):
        do {
          let data = try response.mapJSON()
          debugPrint("data ", data)
          
          if let datadict = data as? NSDictionary {
            if let error = datadict.object(forKey: "errors") as? NSArray {
              completionBlock!(1, error[0] as? String)
            } else {
              //TO-DO save new curren user dictionaru to userDefaults
              completionBlock!(response.statusCode,"Success")
            }
          }
        } catch {
          completionBlock!(response.statusCode, "Error")
        }
      case .failure(let error):
        if let compBlock = completionBlock,
          let response = error.response {
        compBlock(response.statusCode, error.localizedDescription)
        }
      }
    }
  }
  
  func deleteUser(userId: Int, completionBlock: (UpdateUserResponseClosure)? = nil) {
    APIProvider.request(.destroyUser(userId)) { (result) in
      switch result {
      case .success(let response):
        do {
          let data = try response.mapJSON()
          debugPrint("data ", data)
          
          if let datadict = data as? NSDictionary {
            if let error = datadict.object(forKey: "errors") as? NSArray {
              completionBlock!(response.statusCode, error[0] as? String)
            } else {
              completionBlock!(response.statusCode,"Success")
            }
          }
        } catch {
          completionBlock!(response.statusCode, "Error")
        }
      case .failure(let error):
        if let compBlock = completionBlock,
          let response = error.response {
        compBlock(response.statusCode, error.localizedDescription)
        }
      }
    }
  }

  
}
