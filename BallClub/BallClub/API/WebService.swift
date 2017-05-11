//
//  WebService.swift
//  Zukii-Consumer
//
//  Created by Sedrix Caritero on 10/27/16.
//  Copyright © 2016 Sedrix Caritero. All rights reserved.
//

import Foundation
import Moya
import Alamofire

let endpointClosure = { (target: BallClub) -> Endpoint<BallClub> in
  
  let endpoint: Endpoint<BallClub> = Endpoint<BallClub>(URL: url(route: target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
  print("\n\n****************** API Call *********************")
  print("\nurl: \(endpoint.URL)")
  print("\ntarget \(target)")
  print("\ntarget headers \(target.headers)")
  print("\ntarget params \(target.parameters)")
  print("\ntarget method \(target.method)")
  print("\ntarget params encoding \(target.parameterEncoding)")
  print("\n****************** API Call *********************\n\n")
  
  return endpoint.endpointByAddingHTTPHeaderFields(target.headers)
}

private func JSONResponseDataFormatter(data: Data) -> Data {
  do {
    let dataAsJSON = try JSONSerialization.jsonObject(with: data, options: [])
    let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
    return prettyData
  } catch {
    return data //fallback to original data if it cant be serialized
  }
}

let APIProvider = MoyaProvider<BallClub>(endpointClosure: endpointClosure, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// use this if you want to just stub the returned response from the API
//let APIProvider = MoyaProvider<Zukii>(stubClosure: MoyaProvider.ImmediatelyStub)


enum BallClub {
  //Registration API Calls
  case userSignIn(String, String)
  case upload(Data)
  case register([String:Any])
  case getToken(String, String, String)
  
  
  //User API Calls
  case getCurrentUser(Int)
  case getAllUsers()
  case updateUser(Int, [String:Any])
  case destroyUser(Int)
  
  //Friends API Calls
  case getPendingRequests()
  case createFreindRequest(Int)
  case acceptFriendRequests(Int)
  case deleteRequest(Int)
  case getFriendsList()
  case deleteFriend(Int)
  case createInvite([String:Any])
  case getAcceptedInvites()
  case getDeclinedInvites()
  case getPendingInvites()
  case updateInvite(Int, [String:Any])
  case deleteInvite(Int)
  case getUserFriendsList(Int)
  
  //Game API Calls
  case getAllGames()
  case getUserGames(Int)
  case getGamesByLocation(Int)
  case getAllGamesFromYearWeek(String)
  case getUserGamesFromYearWeek(String, Int)
  case getGameDetails(Int, Int)
  case createGame([String : Any])
  case updateGame([String : Any])
  case deleteGame(Int)
  
  //Friends API Calls
  
  
  //Location API Calls
  case getAllLocations()
  case createLocation([String : Any])
  case updateLocation(Int, [String : Any])
  case deleteLocation(Int)
}

private extension String {
  var urlEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}

extension BallClub: TargetType {
  var baseURL: URL { return URL(string: "http://54.238.155.220:3000")! }
  
  var path: String {
    switch self {
    //Registration Related Calls
    case .userSignIn(_, _):
      return "/auth/sign_in"
    case .getToken(_,_,_):
      return "/oauth/token"
    case .register(_):
      return "/api/users"
      
    //User Related Calls
    case .upload(_):
      return "/users/me/image"
    case .getCurrentUser(let userId):
      return "/api/users/\(userId)"
    case .getAllUsers(_):
      return "/api/users"
    case .updateUser(let userId, _):
      return "/api/users/\(userId)"
    case .destroyUser(let userId):
      return "/api/user/\(userId)"
      
  //Friends Related Calls
    case .getPendingRequests():
      return "/api/friend_requests"
    case .createFreindRequest(_):
      return "/api/friend_requests"
    case .acceptFriendRequests(let requestId):
      return "/api/friend_requests/\(requestId)"
    case .deleteRequest(let requestId):
      return "/api/friend_requests/\(requestId)"
    case .getFriendsList():
      return "/api/friends"
    case .deleteFriend(let friendId):
      return "/api/friends/\(friendId)"
    case .createInvite(_):
      return "/api/invites"
    case .getAcceptedInvites():
      return "/api/invites/accepted"
    case .getDeclinedInvites():
      return "/api/invites/declined"
    case .getPendingInvites():
      return "/api/invites/pending"
    case .updateInvite(let inviteId, _):
      return "/api/invites/\(inviteId)"
    case .deleteInvite(let inviteId):
      return "/api/invites/\(inviteId)"
    case .getUserFriendsList(let userId):
      return "/api/users/\(userId)/friends"

      
    //Game Related Calls
    case .getAllGames():
      return "/api/games"
    case .getUserGames(let userId):
      return "/api/users/\(userId)/games"
    case .getGamesByLocation(let locationId):
      return "/api/locations/\(locationId)/games"
    case .getAllGamesFromYearWeek(let yearWeek):
      return "/api/games?year_week=\(yearWeek)"
    case .getUserGamesFromYearWeek(let yearWeek, let userId):
      return "/api/users/\(userId)/games?year_week=\(yearWeek)"
    case .getGameDetails(let userId, let gameId):
      return "/api/users/\(userId)/games/\(gameId)"
    case .createGame(_):
        return "/api/games"
    case .updateGame(let gameDict):
      if let userId = gameDict["userId"], let gameId = gameDict["gameId"] {
        return "/api/users/\(userId)/games/\(gameId)"
      }
      return ""
    case .deleteGame(let gameId):
      return "/api/games/\(gameId)"
    
    
    //Location Related Calls
    case .getAllLocations:
      return "/api/locations"
    case .createLocation(_):
      return "/api/locations"
    case .updateLocation(let locationId, _):
      return "/api/locations/\(locationId)"
    case .deleteLocation(let locationId):
      return "/api/locations/\(locationId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .userSignIn, .createGame, .createLocation, .register, .createFreindRequest, .createInvite, .getToken:
      return .POST
    case .updateGame, .updateUser, .updateInvite, .acceptFriendRequests, .updateLocation:
      return .PATCH
    case .deleteGame, .deleteLocation, .destroyUser, .deleteRequest, .deleteFriend, .deleteInvite:
      return .DELETE
    default:
      return .GET
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
    //Registration Related Calls
    case .userSignIn(let emailAddress, let password) :
      return ["email" : emailAddress,
              "password" : password]
    case .upload(_):
      return nil
    case .register(let user):
      return ["user" :user]
    case .getToken(let clientId, let clientSecret, let clientCredentials):
      return ["client_id": clientId,
      "client_secret": clientSecret,
      "grant_type": clientCredentials]
      
    //User Related Calls
    case .updateUser(_, let user):
      return ["user" : user]
      
   //Friends Related Calls
    case .createFreindRequest(let friendId):
      return ["friend_id": friendId]
    case .createInvite(let invite):
      return ["invite": invite]
    case .updateInvite(_, let invite):
      return ["invite": invite]

    //Game Releted Calls
    case .createGame(let gameDict):
      guard let _ = gameDict["title"],
        let _ = gameDict["start_time"],
        let _ = gameDict["end_time"],
        let _ = gameDict["reserved"],
        let _ = gameDict["min_capacity"],
        let _ = gameDict["max_capacity"],
        let _ = gameDict["fee"],
        let _ = gameDict["additional_info"],
        let _ = gameDict["location_id"] else { return nil }
      return ["game" : gameDict]
    case .updateGame(let gameDict):
      return ["game" : gameDict]
      
    //Location Related Calls
    case .createLocation(let locationDict):
      guard let _ = locationDict["name"],
        let _ = locationDict["longitude"],
        let _ = locationDict["latitude"] else { return nil }
      return ["location" : locationDict]
    case .updateLocation(_, let locationDict):
      return ["location" : locationDict]
    default:
      return nil
    }
  }
  
  var task: Task {
    switch self {
    case let .upload(data):
      return .upload(.multipart([MultipartFormData(provider: .data(data), name: "file", fileName: "profileImage.jpg", mimeType: "image/jpeg")]))
    default:
      return .request
    }
  }
  
  var parameterEncoding: ParameterEncoding {
    switch self {
    case .userSignIn, .createGame, .createLocation, .updateLocation, .updateGame, .register, .updateUser,
         .createFreindRequest, .createInvite, .getToken, .updateInvite:
      return Alamofire.JSONEncoding.default
    default:
      return Alamofire.URLEncoding.default
    }
  }
  
  var headers: [String: String] {
    return [
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + (SessionManager.sharedInstance.getSessionToken() ?? "")!,
      "access-token": (SessionManager.sharedInstance.getAccessToken() ?? "")!,
      "client": (SessionManager.sharedInstance.getClient() ?? "")!,
      "expiry": UserDefaults.standard.object(forKey: "expiry") as? String ?? "",
      "uid": (SessionManager.sharedInstance.getUsername() ?? "")!,
      "token-type": "Bearer"
    ]
  }
  
  var sampleData: Data {
    switch self {
    case .userSignIn:
      return stubbedResponse("login")
    default:
      return NSData() as Data
    }
  }
  
}

func stubbedResponse(_ filename: String) -> Data! {
  let bundle = Bundle.main
  let path = bundle.path(forResource: filename, ofType: "json")
  return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

/*func url(_ route: TargetType) -> String {
 return route.baseURL.appendingPathComponent(route.path).absoluteString
 }*/

func url(route: TargetType) -> String {
  let url = NSURL(string:route.path, relativeTo:route.baseURL)!
  return url.absoluteString!
}
