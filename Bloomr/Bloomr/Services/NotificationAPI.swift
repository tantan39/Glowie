//
//  NotificationAPI.swift
//  Bloomr
//
//  Created by Tan Tan on 10/12/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import Moya
let NotificationAPIProvider = MoyaProvider<NotificationAPI>(endpointClosure: ServiceHelper.defaultEndpointClosure, manager: DefaultAlamofireManager.sharedManager, plugins: [MoyaLoggerPlugin])

enum NotificationAPI {
    case fetchNotifications(index: Int, limit: Int)
}

extension NotificationAPI: TargetTypeHelper {
    var extendPath: String {
        return ""
    }
    
    var baseURL: URL {
        return Constant.apiBaseUrl
    }
    
    var path: String {
        return "/message/notifications.fetch"
    }
    
    var method: Moya.Method {
        return .get
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
        case .fetchNotifications(let index, let limit):
            return ["index": index,
                    "limit": limit
            ]
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
