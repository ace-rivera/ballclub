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
  
  public typealias UserSignInResponseClosure = (Bool, String?) -> (Void)
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
              
              if let playerDictionary = userDetail{
                //UserDefaults.standard.setValue(playerDictionary, forKey: "currentUser")
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
              completionBlock!(false, error[0] as? String)
            } else {
              completionBlock!(true,"Success")
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
}
