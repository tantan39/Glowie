//
//  PostAPI.swift
//  Bloomr
//
//  Created by Tan Tan on 9/26/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Moya
let PostAPIProvider = MoyaProvider<PostAPI>(endpointClosure: ServiceHelper.defaultEndpointClosure, manager: DefaultAlamofireManager.sharedManager, plugins: [MoyaLoggerPlugin])

enum PostAPI {
    case createPost(posts: [ContentPostUpload])
    case getPostDetail(id: String?)
}

extension PostAPI: TargetTypeHelper {
    var extendPath: String {
        return ""
    }
    
    var baseURL: URL {
        return Constant.apiBaseUrl
    }
    
    var path: String {
        switch self {
        case .createPost(_):
            return "service/feed.create"
        case .getPostDetail(_):
            return "/service/post.get"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createPost(_):
            return .post
        case .getPostDetail(_):
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
        case .createPost(let posts):
            var payload = [[String: Any]]()
            for item in posts {
                if let json = item.export().dictionaryObject {
                    payload.append(json)
                }
            }
            return ["payload": payload]
            
        case .getPostDetail(let id):
            return ["post_id": id ?? ""]
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
