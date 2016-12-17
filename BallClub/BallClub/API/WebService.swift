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
  //User API Calls
  case login(String, String)
  case upload(Data)
  
  //Game API Calls
}

private extension String {
  var urlEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}

extension BallClub: TargetType {
  var baseURL: URL { return URL(string: "https://ballclub.herokuapp.com")! }
  
  var path: String {
    switch self {
    //Account Related Calls
    case .login:
      return "/auth/sign_in"
    case .upload(_):
      return "/users/me/image"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .login:
      return .POST
//    case :
//      return .PUT
    default:
      return .GET
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
    //Account Related Calls
    case .login(let emailAddress, let password) :
      return ["email" : emailAddress,
              "password" : password]
    case .upload(_):
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
    case .login: // for post api calls
      return Alamofire.JSONEncoding.prettyPrinted
    default:
      return Alamofire.URLEncoding.default
    }
  }
  
  var headers: [String: String] {
    return [
      "Content-Type": "application/json",
      "Accept": "application/json"
      //"Authorization": "Bearer " + (SessionManager.sharedInstance.getSessionToken() ?? "")!]
    ]
  }
  
  var sampleData: Data {
    switch self {
    case .login:
      return stubbedResponse("login")
//    case .register:
//      return stubbedResponse("register")
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
