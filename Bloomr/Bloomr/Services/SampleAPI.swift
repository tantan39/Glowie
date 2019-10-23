//
//  SampleAPI.swift
//  Bloomr
//
//  Created by Tan Tan on 10/1/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Moya

let SampleAPIProvider = MoyaProvider<SampleAPI>(endpointClosure: ServiceHelper.defaultEndpointClosure, manager: DefaultAlamofireManager.sharedManager, plugins: [MoyaLoggerPlugin])

enum SampleAPI {
    case getActiveAlbumContest
    case getPosts
}

extension SampleAPI: TargetTypeHelper {
    var extendPath: String {
        return ""
    }
    
    var baseURL: URL {
        return URL(string: "http://192.168.1.115:1337")!
    }
    
    var path: String {
        switch self {
        case .getActiveAlbumContest:
            return "/galleries.get"
        case .getPosts:
            return "/message"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var parameters: [String: Any]? {
        return [:]
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
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
