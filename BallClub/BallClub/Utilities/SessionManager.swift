//
//  SessionManager.swift
//  BallClub
//
//  Created by Don Joseph Rivera on 07/01/2017.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import Foundation
import KeychainAccess

class SessionManager: NSObject {
  
  static let sharedInstance = SessionManager()
  let keychain = Keychain(service: "com.fatalException.BallClub")
  var username = ""
  
  func saveSession(username: String, token: String) {
    do {
      try keychain.set(username, key: "username")
      try keychain.set(token, key: "user-token")
      self.username = username
    } catch let error {
      print(error)
    }
  }
  
  func logout() {
    deleteResources()
    endCurrentSession()
  }
  
  func getSessionToken() -> String? {
    do {
      if let token = try keychain.get("user-token") {
        return token
      }
      return nil
    } catch let error {
      print(error)
      return nil
    }
  }
  
  func getUsername() -> String? {
    do {
      if let username = try keychain.get("username") {
        self.username = username
        return username
      }
      return nil
    } catch let error {
      print(error)
      return nil
    }
  }
  
  func endCurrentSession() {
    do {
      try keychain.remove("username")
      try keychain.remove("user-token")
    } catch let error {
      print("error: \(error)")
    }
  }
  
  func deleteResources() {
    //TO DO: delete cahced resources
  }
}