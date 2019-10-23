//
//  FlowerAPI.swift
//  Bloomr
//
//  Created by Tan Tan on 9/26/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Moya
let FlowerAPIProvider = MoyaProvider<FlowerAPI>(endpointClosure: ServiceHelper.defaultEndpointClosure, manager: DefaultAlamofireManager.sharedManager, plugins: [MoyaLoggerPlugin])

enum FlowerAPI {
    case giveFlowerOnRace(flower: Int, contest: String, ckey: String?, model: Int)
}

extension FlowerAPI: TargetTypeHelper {
    var extendPath: String {
        return ""
    }
    
    var baseURL: URL {
        return Constant.apiBaseUrl
    }
    
    var path: String {
        return "/api/flower.give"
    }
    
    var method: Moya.Method {
        return .post
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
        case .giveFlowerOnRace(let flower, let contest, let ckey, let model):
            
            var given = ["flower": flower,
                         "model": model,
                         "key": contest
                ] as [String: Any]
            
            if let ckey = ckey {
                given.updateValue(ckey, forKey: "ckey")
            }
            return ["given": given]
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
