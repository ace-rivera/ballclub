//
//  LocationViewModel.swift
//  BallClub
//
//  Created by Joshua Relova on 1/7/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import SwiftyJSON
import Gloss

class LocationViewModel: NSObject {

  public typealias LocationsResponseClosure = (Int, String?, [Location]?) -> (Void)
  public typealias CreateLocationResponseClosure = (Int, String?, Location?) -> (Void)
  
  func getLocations(completionBlock: LocationsResponseClosure? = nil) {
    var locationList = [Location]()
    APIProvider.request(.getAllLocations()) { (result) in
      
      switch result {
      case.success(let response):
        do {
          //200 OK
          let data = try response.mapJSON()
          debugPrint("data ", data)
          if let dataArray = data as? [[String : Any]] {
            for locationData in dataArray {
              if let l = Location(json: locationData) {
                locationList.append(l)
              }
            }
            completionBlock!(response.statusCode, "Games Retrieved Successfully", locationList)
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
  
  func createLocation(locationDict: [String : Any], completionBlock: CreateLocationResponseClosure? = nil) {
    APIProvider.request(.createLocation(locationDict)) { (result) in
      switch result {
      case.success(let response):
        do {
          //201 Created
          let data = try response.mapJSON()
          debugPrint("data ", data)
          if let dataDict = data as? [String : Any],
            let l = Location(json: dataDict) {
            completionBlock!(response.statusCode, "Location Created Successfully", l)
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
  
  func updateLocation(locationId: Int, locationDict: [String : Any], completionBlock: CreateLocationResponseClosure? = nil) {
    APIProvider.request(.updateLocation(locationId, locationDict)) { (result) in
      switch result {
      case.success(let response):
        do {
          //201 Created
          let data = try response.mapJSON()
          debugPrint("data ", data)
          if let dataDict = data as? [String : Any],
            let l = Location(json: dataDict) {
            completionBlock!(response.statusCode, "Location Created Successfully", l)
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
  
  func deleteLocation(locationId: Int, completionBlock: ((Int, String?) -> (Void))? = nil) {
    APIProvider.request(.deleteLocation(locationId)) { (result) in
      switch result {
      case.success(let response):
        do {
          //204 NO CONTENT
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
