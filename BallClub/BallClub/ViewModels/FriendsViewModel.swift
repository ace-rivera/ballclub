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
    
    public typealias DefaultRequestResponseClosure = (Int, String?) -> (Void)
    public typealias GetAllUserResponseClosure = (Int, String, [Player]?) -> (Void)
    public typealias GetPendingRequestsResponseClosure = (Int, String, [Request]?, [Request]?, Int?, Bool?) -> (Void)
    public typealias GetFriendsListResponseClosure = (Int, String?, [Player]?) -> (Void)
    public typealias GetInvitesResponseClosure = (Int, String, [Invite]?) -> (Void)
    public typealias CreateInviteResponseClosure = (Int, String, Invite?) -> (Void)
    
    var incomingRequestArray = [Request]()
    var outgoingRequestArray = [Request]()
    var myFriendsArray = [Player]()
    var myInvites = [Invite]()
    var userFriendsArray = [Player]()
    var currentUser = UserDefaults.standard.object(forKey: "currentUser") as? [String:Any]
    
    func getPendingRequests(completionBlock: (GetPendingRequestsResponseClosure)? = nil ) {
        incomingRequestArray = [Request]()
        outgoingRequestArray = [Request]()
        APIProvider.request(.getPendingRequests()) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    var pendingRequestFriendID = -1
                    let userId = self.currentUser?["id"] as? Int
                    var isFriendAdded = false
                    
                    debugPrint("data ", data)
                    
                    if let requestDictionary = data as? [String: Any] {
                        if let error = requestDictionary["errors"] as? NSArray, let errorMessage = error[0] as? String {
                            completionBlock!(response.statusCode, errorMessage, nil, nil, nil, nil)
                        } else {
                            
                            if let incomingRequsts = requestDictionary["incoming"] as? NSArray {
                                for request in incomingRequsts {
                                    if let incomingReqDictionary = request as? [String:Any], let p = Request(json:incomingReqDictionary) {
                                        if (userId == p.friendId) {
                                            isFriendAdded = true
                                        }
                                        self.incomingRequestArray.append(p)
                                    }
                                }
                            }
                            
                            if let outgoingRequsts = requestDictionary["outgoing"] as? NSArray {
                                for request in outgoingRequsts {
                                    if let outgoingReqDictionary = request as? [String:Any], let p = Request(json:outgoingReqDictionary) {
                                        pendingRequestFriendID = p.friendId
                                        self.outgoingRequestArray.append(p)
                                    }
                                }
                            }
                            
                            completionBlock!(response.statusCode, "User retrieved successfully", self.incomingRequestArray, self.outgoingRequestArray, pendingRequestFriendID, isFriendAdded)
                            
                        }
                    }
                } catch {
                    completionBlock!(response.statusCode, "Error", nil, nil, nil, nil)
                }
            case .failure(let error):
                if let compBlock = completionBlock,
                    let response = error.response {
                    compBlock(response.statusCode, error.localizedDescription, nil, nil, nil, nil)
                }
            }
        }
    }
    
    func createFriendRequest(friendId: Int, completionBlock: (DefaultRequestResponseClosure)? = nil) {
        APIProvider.request(.createFreindRequest(friendId)) { (result) in
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
    
    
    func acceptFriendRequest(requestId: Int, completionBlock: (DefaultRequestResponseClosure)? = nil) {
        APIProvider.request(.acceptFriendRequests(requestId)) { (result) in
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
    
    func deleteFriendRequest(requestId: Int, completionBlock: (DefaultRequestResponseClosure)? = nil) {
        APIProvider.request(.deleteRequest(requestId)) { (result) in
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
    
    func getFriendsList(completionBlock: (GetFriendsListResponseClosure)? = nil) {
        self.myFriendsArray = [Player]()
        APIProvider.request(.getFriendsList()) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    debugPrint("data ", data)
                    
                    if let dataDict = data as? NSArray {
                        //            if let error = datadict.object(forKey: "errors") as? NSArray {
                        //              completionBlock!(false, error[0] as? String)
                        //            } else {
                        //}
                        
                        for friend in dataDict {
                            if let playerDictionary = friend as? [String:Any], let p = Player(json:playerDictionary) {
                                self.myFriendsArray.append(p)
                            }
                        }
                        completionBlock!(response.statusCode, "Error", self.myFriendsArray)
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
    
    func deleteFriend(friendId: Int, completionBlock: (DefaultRequestResponseClosure)? = nil) {
        APIProvider.request(.deleteFriend(friendId)) { (result) in
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
    
    func createInvite(invite: [String:Any], completionBlock: (CreateInviteResponseClosure)? = nil) {
        APIProvider.request(.createInvite(invite)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    debugPrint("data ", data)
                    
                    if let datadict = data as? [String:Any] {
                        if let error = datadict["errors"] as? NSArray, let message = error[0] as? String {
                            completionBlock!(response.statusCode, message, nil)
                        } else {
                            if let p = Invite(json: datadict){
                                completionBlock!(response.statusCode, "Invite Sent to Player", p)
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
    
    func getAcceptedIvites(completionBlock: (GetInvitesResponseClosure)? = nil) {
        myInvites = [Invite]()
        APIProvider.request(.getFriendsList()) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    debugPrint("data ", data)
                    
                    if let dataDict = data as? NSArray {
                        //            if let error = datadict.object(forKey: "errors") as? NSArray {
                        //              completionBlock!(false, error[0] as? String)
                        //            } else {
                        //}
                        
                        for invite in dataDict {
                            if let inviteDictionary = invite as? [String:Any], let p = Invite(json:inviteDictionary) {
                                self.myInvites.append(p)
                            }
                        }
                        completionBlock!(response.statusCode, "Success", self.myInvites)
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
    
    func getDeclinedIvites(completionBlock: (GetInvitesResponseClosure)? = nil) {
        myInvites = [Invite]()
        APIProvider.request(.getDeclinedInvites()) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    debugPrint("data ", data)
                    
                    if let dataDict = data as? NSArray {
                        //            if let error = datadict.object(forKey: "errors") as? NSArray {
                        //              completionBlock!(false, error[0] as? String)
                        //            } else {
                        //}
                        
                        for invite in dataDict {
                            if let inviteDictionary = invite as? [String:Any], let p = Invite(json:inviteDictionary) {
                                self.myInvites.append(p)
                            }
                        }
                        completionBlock!(response.statusCode, "Success", self.myInvites)
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
    
    func getPendingIvites(completionBlock: (GetInvitesResponseClosure)? = nil) {
        myInvites = [Invite]()
        APIProvider.request(.getPendingInvites()) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    debugPrint("data ", data)
                    
                    if let dataDict = data as? NSArray {
                        //            if let error = datadict.object(forKey: "errors") as? NSArray {
                        //              completionBlock!(false, error[0] as? String)
                        //            } else {
                        //}
                        
                        for invite in dataDict {
                            if let inviteDictionary = invite as? [String:Any], let p = Invite(json:inviteDictionary) {
                                self.myInvites.append(p)
                            }
                        }
                        completionBlock!(response.statusCode, "Success", self.myInvites)
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
    
    func updateInvite(inviteId: Int, invite: [String: Any], completionBlock: (DefaultRequestResponseClosure)? = nil) {
        myInvites = [Invite]()
        APIProvider.request(.updateInvite(inviteId, invite)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    debugPrint("data ", data)
                    
                    if let dataDict = data as? NSDictionary {
                        if let error = dataDict.object(forKey: "errors") as? NSArray {
                            completionBlock!(response.statusCode, error[0] as? String)
                        } else {
                            completionBlock!(response.statusCode, "Success")
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
    
    func deleteInvite(inviteId: Int, completionBlock: (DefaultRequestResponseClosure)? = nil) {
        myInvites = [Invite]()
        APIProvider.request(.deleteInvite(inviteId)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    debugPrint("data ", data)
                    
                    if let dataDict = data as? NSDictionary {
                        if let error = dataDict.object(forKey: "errors") as? NSArray {
                            completionBlock!(response.statusCode, error[0] as? String)
                        } else {
                            completionBlock!(response.statusCode, "Success")
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
    
    func getUserFriendsList(userId: Int, completionBlock: (GetFriendsListResponseClosure)? = nil) {
        self.userFriendsArray = [Player]()
        APIProvider.request(.getUserFriendsList(userId)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    debugPrint("data ", data)
                    
                    if let dataDict = data as? NSArray {
                        //            if let error = datadict.object(forKey: "errors") as? NSArray {
                        //              completionBlock!(false, error[0] as? String)
                        //            } else {
                        //}
                        
                        for friend in dataDict {
                            if let playerDictionary = friend as? [String:Any], let p = Player(json:playerDictionary) {
                                self.userFriendsArray.append(p)
                            }
                        }
                        completionBlock!(response.statusCode, "Error", self.userFriendsArray)
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
    
    
}
