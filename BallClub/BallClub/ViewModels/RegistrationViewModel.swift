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
  
  public typealias UserSignInResponseClosure = (Int, String?, String?, String?) -> (Void)
  public typealias UserRegistrationResponseClosure = (Int, String?) -> (Void)
  public typealias GetTokenResponseClosure = (Int, String?, String?) -> (Void)
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
              completionBlock!(response.statusCode, error[0] as? String, nil, nil)
            } else {
              let userDetail = datadict.object(forKey: "data") as? [String:Any]
              
              if let playerDictionary = userDetail, let httpResponse = response.response as? HTTPURLResponse, let accessToken = httpResponse.allHeaderFields["access-token"] as? String,
                let client = httpResponse.allHeaderFields["client"] as? String, let expiry = httpResponse.allHeaderFields["expiry"] as? String {
                UserDefaults.standard.setValue(playerDictionary, forKey: "currentUser")
                UserDefaults.standard.set(expiry, forKey: "expiry")
                completionBlock!(response.statusCode,"Success", accessToken, client)
              } else {
                
                completionBlock!(response.statusCode, "Error", nil, nil)
              }
            }
            
          }
          
        } catch {
          completionBlock!(response.statusCode, "Error", nil, nil)
        }
      case .failure(let error):
        if let compBlock = completionBlock,
          let response = error.response {
        compBlock(response.statusCode, error.localizedDescription, nil, nil)
        }
      }
    }
  }
  
  func getToken(clientId: String, clientSecret: String, grantType:String, completionBlock: (GetTokenResponseClosure)? = nil) {
    APIProvider.request(.getToken(clientId, clientSecret, grantType)) { (result) in
      switch result {
      case .success(let response):
        do {
          let data = try response.mapJSON()
          debugPrint("data ", data)
          
          if let datadict = data as? NSDictionary {
            if let error = datadict.object(forKey: "errors") as? NSArray {
              completionBlock!(1, error[0] as? String, nil)
            } else {
              UserDefaults.standard.set((datadict["expires_in"] as? String) ?? "", forKey: "Expiry")
              completionBlock!(response.statusCode,"Success", (datadict["access_token"] as? String) ?? "")
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
  
  func registerUser(userCredentials: [String:Any], completionBlock: (UserRegistrationResponseClosure)? = nil) {
    APIProvider.request(.register(userCredentials)) { (result) in
      switch result {
      case .success(let response):
        do {
          let data = try response.mapJSON()
          debugPrint("data ", data)
          
          if let datadict = data as? NSDictionary {
            if let error = datadict.object(forKey: "errors") as? NSArray {
              completionBlock!(1, error[0] as? String)
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
