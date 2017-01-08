//
//  FriendsViewModel.swift
//  BallClub
//
//  Created by Joshua Relova on 1/7/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import SwiftyJSON
import Gloss

class FriendsViewModel: NSObject {
  
  public typealias CreateRequestResponseClosure = (Bool, String?) -> (Void)
  public typealias GetAllUserResponseClosure = (Bool, String, [Player]?) -> (Void)
  public typealias GetPendingRequestsResponseClosure = (Bool, String, [Request]?, [Request]?) -> (Void)
  
  var incomingRequestArray = [Request]()
  var outgoingRequestArray = [Request]()
  
  func getPendingRequests(completionBlock: (GetPendingRequestsResponseClosure)? = nil ) {
    APIProvider.request(.getPendingRequests()) { (result) in
      switch result {
      case .success(let response):
        do {
          let data = try response.mapJSON()
          debugPrint("data ", data)
          
          if let requestDictionary = data as? [String: Any] {
            if let error = requestDictionary["errors"] as? NSArray, let errorMessage = error[0] as? String {
              completionBlock!(false, errorMessage, nil, nil)
            } else {
              
              if let incomingRequsts = requestDictionary["incoming"] as? NSArray {
                for request in incomingRequsts {
                  if let incomingReqDictionary = request as? [String:Any], let p = Request(json:incomingReqDictionary) {
                    self.incomingRequestArray.append(p)
                  }
                }
              }
              
              if let outgoingRequsts = requestDictionary["outgoing"] as? NSArray {
                for request in outgoingRequsts {
                  if let outgoingReqDictionary = request as? [String:Any], let p = Request(json:outgoingReqDictionary) {
                    self.outgoingRequestArray.append(p)
                  }
                }
              }
              
             completionBlock!(true, "User retrieved successfully", self.incomingRequestArray, self.outgoingRequestArray)
      
            }
          }
        } catch {
          completionBlock!(false, "Error", nil, nil)
        }
      case .failure(let error):
        completionBlock!(false, error.localizedDescription, nil, nil)
      }
    }
  }
  
  func createFriendRequest(friendId: Int, completionBlock: (CreateRequestResponseClosure)? = nil) {
    APIProvider.request(.createFreindRequest(friendId)) { (result) in
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
  
  func deleteFriendRequest(requestId: Int, completionBlock: (CreateRequestResponseClosure)? = nil) {
    APIProvider.request(.deleteRequest(requestId)) { (result) in
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
