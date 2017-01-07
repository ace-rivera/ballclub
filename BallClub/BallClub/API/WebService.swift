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
  
  let endpoint: Endpoint<BallClub> = Endpoint<BallClub>(URL: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
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
  case getToken()
  
  
  //User API Calls
  case getCurrentUser(Int)
  case getAllUsers()
  case updateUser(Int, [String:Any])
  case destroyUser(Int)
  
  
  //Game API Calls
  case getUserGames(Int)
  case getGameDetails(Int, Int)
  case createGame([String : Any])
  case updateGame([String : Any])
  case deleteGame(Int, Int)
  
  //Friends API Calls
  
  
  //Location API Calls
  
}

private extension String {
  var urlEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}

extension BallClub: TargetType {
  var baseURL: URL { return URL(string: "http://192.241.180.14:4000")! }
  
  var path: String {
    switch self {
    //Registration Related Calls
    case .userSignIn(_, _):
      return "/auth/sign_in"
    case .getToken():
      return "/api/oauth/token"
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

    //Game Related Calls
    case .getUserGames(let userId):
      return "/api/users/\(userId)/games"
    case .getGameDetails(let userId, let gameId):
      return "/api/users/\(userId)/games/\(gameId)"
    case .createGame(let gameDict):
      if let userId = gameDict["userId"] {
        return "/api/users/\(userId)/games"
      }
      return ""
    case .updateGame(let gameDict):
      if let userId = gameDict["userId"], let gameId = gameDict["gameId"] {
        return "/api/users/\(userId)/games/\(gameId)"
      }
      return ""
    case .deleteGame(let userId, let gameId):
      return "/api/users/\(userId)/games/\(gameId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .userSignIn, .createGame, .register:
      return .POST
    case .updateGame, .updateUser:
      return .PATCH
    case .deleteGame, .destroyUser:
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
      
    //User Related Calls
    case .updateUser(_, let user):
      return ["user" : user]

    //Game Releted Calls
    case .createGame(let gameDict):
      guard let _ = gameDict["title"],
        let _ = gameDict["start_time"],
        let _ = gameDict["end_time"],
        let _ = gameDict["reserved"],
        let _ = gameDict["minCapacity"],
        let _ = gameDict["maxCapacity"],
        let _ = gameDict["fee"],
        let _ = gameDict["additionalInfo"],
        let _ = gameDict["locationId"] else { return nil }
      return ["game" : gameDict]
    case .updateGame(let gameDict):
      return ["game" : gameDict]
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
    case .userSignIn, .createGame, .updateGame, .register, .updateUser: // for POST and PATCH api calls
      return Alamofire.JSONEncoding.prettyPrinted
    default:
      return Alamofire.URLEncoding.default
    }
  }
  
  var headers: [String: String] {
    return [
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer 5a5555337d1587c852b97d3b884a22282bcb425f47fd55485c165c0b1ed841ea", //+ (SessionManager.sharedInstance.getSessionToken() ?? "")!],
      "access-token": "MQlszVM5Hcj8NgiF6_GGqw",
      "client": "_mSXc-tDgBkJ_E1h7C9Uyw",
      "expiry": "1485002437",
      "uid": "k.paras@gmail.com",
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

func url(_ route: TargetType) -> String {
  return route.baseURL.appendingPathComponent(route.path).absoluteString
}
