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
  
  func saveSession(username: String, token: String, accessToken: String, client: String) {
    do {
      try keychain.set(username, key: "username")
      try keychain.set(token, key: "user-token")
      try keychain.set(accessToken, key: "access-token")
      try keychain.set(client, key: "client")
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
  
  func getAccessToken() -> String? {
    do {
      if let accessToken = try keychain.get("access-token") {
        return accessToken
      }
      return nil
    } catch let error {
      print(error)
      return nil
    }
  }
  
  func getClient() -> String? {
    do {
      if let client = try keychain.get("client") {
        return client
      }
      return nil
    } catch let error {
      print(error)
      return nil
    }
  }
  
  func isTokenExpired() -> Bool {
    if let expiry = UserDefaults.standard.value(forKey: "expiry") as? String,
      let loginTime = UserDefaults.standard.value(forKey: "loginTime") as? Date {
      
      let calendar = Calendar.current
      let minutes = Int(expiry) ?? 0
      let dateAfterAddingTTL = calendar.date(byAdding: .second, value: seconds, to: loginTime) ?? Date()
      
      let timeNow = Date()
      
      if timeNow > dateAfterAddingTTL {
        return true
      }
    }
    return false
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
