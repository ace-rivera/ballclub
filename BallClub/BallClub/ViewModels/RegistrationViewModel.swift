//
//  RegistrationViewModel.swift
//  BallClub
//
//  Created by Joshua Relova on 1/7/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import SwiftyJSON
import Gloss

class RegistrationViewModel: NSObject {
  
  public typealias UserSignInResponseClosure = (Int, String?) -> (Void)
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
              completionBlock!(response.statusCode, error[0] as? String)
            } else {
              let userDetail = datadict.object(forKey: "data") as? [String:Any]
              
              if let playerDictionary = userDetail{
                //UserDefaults.standard.setValue(playerDictionary, forKey: "currentUser")
                completionBlock!(response.statusCode,"Success")
              } else {
                
                completionBlock!(response.statusCode, "Error")
              }
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
  
  func getToken() {
    
  }
  
  func registerUser(userCredentials: [String:Any], completionBlock: (UserSignInResponseClosure)? = nil) {
    APIProvider.request(.register(userCredentials)) { (result) in
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
