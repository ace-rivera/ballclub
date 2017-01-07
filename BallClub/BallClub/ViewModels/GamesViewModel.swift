//
//  GamesViewModel.swift
//  BallClub
//
//  Created by Joshua Relova on 1/7/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import SwiftyJSON
import Gloss

class GamesViewModel: NSObject {
  public typealias GamesResponseClosure = (Int, String?, [Game]?) -> (Void)
  public typealias GameDetailClosure = (Int, String?, Game?) -> (Void)
  
  func getCurrentUserGames(completionBlock: GamesResponseClosure? = nil) {
    var gameList = [Game]()
    if let currentUser = UserDefaults.standard.value(forKey: "currentUser") as? [String : Any],
      let userId = currentUser["userId"] as? Int {
      APIProvider.request(.getUserGames(userId)) { (result) in
        
        switch result {
        case.success(let response):
          do {
            let data = try response.mapJSON()
            debugPrint("data ", data)
            if let dataArray = data as? [[String : Any]] {
              for gameData in dataArray {
                //use gameData to create game
                if let g = Game(json: gameData) {
                  gameList.append(g)
                }
              }
              completionBlock!(response.statusCode, "Games Retrieved Successfully", gameList)
            } else {
              completionBlock!(response.statusCode, "Error", nil)
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
  
  func getGameDetails(gameId: Int, completionBlock: GameDetailClosure? = nil) {
    if let currentUser = UserDefaults.standard.value(forKey: "currentUser") as? [String : Any],
      let userId = currentUser["userId"] as? Int {
      APIProvider.request(.getGameDetails(userId, gameId)) { (result) in
        
        switch result {
        case.success(let response):
          do {
            let data = try response.mapJSON()
            debugPrint("data ", data)
            if let dataDict = data as? [String : Any],
              let g = Game(json: dataDict) {
              completionBlock!(response.statusCode, "Game Retrieved Successfully", g)
            } else {
              completionBlock!(response.statusCode, "Error", nil)
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
  
  func createGame(gameDict: [String : Any], completionBlock: GameDetailClosure? = nil) {
    APIProvider.request(.createGame(gameDict)) { (result) in
      switch result {
      case.success(let response):
        do {
          let data = try response.mapJSON()
          debugPrint("data ", data)
          if let dataDict = data as? [String : Any],
            let g = Game(json: dataDict) {
            completionBlock!(response.statusCode, "Game Created Successfully", g)
          } else {
            completionBlock!(response.statusCode, "Error", nil)
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
  
  func updateGame(gameDict: [String : Any], completionBlock: GameDetailClosure? = nil) {
    APIProvider.request(.updateGame(gameDict)) { (result) in
      switch result {
      case.success(let response):
        do {
          let data = try response.mapJSON()
          debugPrint("data ", data)
          if let dataDict = data as? [String : Any],
            let g = Game(json: dataDict) {
            completionBlock!(response.statusCode, "Game Updated Successfully", g)
          } else {
            completionBlock!(response.statusCode, "Error", nil)
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
  
  func deleteGame(gameId: Int, completionBlock: ((Int, String?) -> (Void))? = nil) {
    if let currentUser = UserDefaults.standard.value(forKey: "currentUser") as? [String : Any],
      let userId = currentUser["userId"] as? Int {
      APIProvider.request(.deleteGame(userId, gameId)) { (result) in
        
        switch result {
        case.success(let response):
          do {
            let data = try response.mapJSON()
            debugPrint("data ", data)
            
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
}
