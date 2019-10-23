//
//  UserAPI.swift
//  Bloomr
//
//  Created by Tan Tan on 9/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Moya
let UserAPIProvider = MoyaProvider<UserAPI>(endpointClosure: ServiceHelper.defaultEndpointClosure, manager: DefaultAlamofireManager.sharedManager, plugins: [MoyaLoggerPlugin])

enum UserAPI {
    case fetchProfile
    case fetchUserProfile(uid: Int)
}

extension UserAPI: TargetTypeHelper {
    var extendPath: String {
        return ""
    }
    
    var baseURL: URL {
        return Constant.apiBaseUrl
    }
    
    var path: String {
        switch self {
        case .fetchProfile:
            return "/account/profile.fetch"
        case .fetchUserProfile(_):
            return "/account/profile.user.fetch"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchProfile:
            return .get
        case .fetchUserProfile(_):
            return .get
        }
        
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var headers: [String: String]? {
        return ["access_token": UserSessionManager.accessToken() ?? "",
                "device_id": DeviceManager.deviceID]
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchProfile:
            return [:]
        case .fetchUserProfile(let uid):
            return ["user_id": uid]
        }
        
    }
    
    var task: Task {
        if self.parameters != nil {
            if self.method == .post {
                return .requestParameters(parameters: self.parameters!, encoding: JSONEncoding.default)
            }
            return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
        }
        return .requestPlain
    }
}
