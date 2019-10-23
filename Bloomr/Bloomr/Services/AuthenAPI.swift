//
//  AuthenAPI.swift
//  Bloomr
//
//  Created by Tan Tan on 10/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Foundation
import Moya

let AuthenAPIProvider = MoyaProvider<AuthenAPI>(endpointClosure: ServiceHelper.defaultEndpointClosure, manager: DefaultAlamofireManager.sharedManager, plugins: [MoyaLoggerPlugin])

enum AuthenAPI {
    case login(secret: String?, countryID: Int?, appID: Int?, credential: String?, notification_token: String?)
    case getOTP(mobile: String?, countryID: Int?)
    case verifyOTPRegister(secret: String?, appID: Int?, credential: String?, notification_token: String?)
    case verifyOTPLogin(secret: String?, appID: Int?, countryID : Int?, credential: String?, notification_token: String?)
}

extension AuthenAPI: TargetTypeHelper {
    var extendPath: String {
        return ""
    }
    
    var baseURL: URL {
        return Constant.apiBaseUrl
    }
    
    var path: String {
        switch self {
        case .login:
            return "/oauth/auth.authentication"
        case.getOTP:
            return "/oauth/auth.get.code"
        case .verifyOTPRegister:
            return "/oauth/auth.register.verify"
        case .verifyOTPLogin:
            return "/oauth/auth.authorizeVerifyByCode"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .getOTP:
            return .post
        case .verifyOTPRegister:
            return .post
        case .verifyOTPLogin:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var headers: [String: String]? {
        return ["device_id": DeviceManager.deviceID]
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let secret, let countryID, let appID, let credential, let notification_token):
            let params: [String: Any] = ["secret_client": secret ?? "",
                          "country_id": countryID ?? 0,
                          "app_id": appID ?? 0,
                          "credential": credential ?? "",
                          "notification_token": notification_token ?? ""
                ]
            return params
            
        case .getOTP(let mobile, let countryID):
            return ["mobile": mobile ?? "",
                    "country_id": countryID ?? 0
            ]
            
        case .verifyOTPRegister(let secret, let appID, let credential, let notification_token):
            let params: [String: Any] = ["secret_client": secret ?? "",
                      "app_id": appID ?? 0,
                      "credential": credential ?? "",
                      "notification_token": notification_token ?? ""
            ]
            return params
            
        case .verifyOTPLogin(let secret, let appID, let countryID, let credential, let notification_token):
            let params: [String: Any] = ["secret_client": secret ?? "",
                          "country_id": countryID ?? 0,
                          "app_id": appID ?? 0,
                          "credential": credential ?? "",
                          "notification_token": notification_token ?? ""
                ]
            return params
        }
    }
    
    public var task: Task {
           if self.parameters != nil {
               if self.method == .post {
                   return .requestParameters(parameters: self.parameters!, encoding: JSONEncoding.default)
               }
               return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
           }
           return .requestPlain
       }
    
}
