//
//  MediaAPI.swift
//  Bloomr
//
//  Created by Tan Tan on 10/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Moya

let MediaAPIProvider = MoyaProvider<MediaAPI>(endpointClosure: ServiceHelper.defaultEndpointClosure, manager: DefaultAlamofireManager.sharedManager, plugins: [MoyaLoggerPlugin])

enum MediaAPI {
    case uploadAudio(data: Data)
    case uploadVideo(data: Data)
}

extension MediaAPI: TargetTypeHelper {
    var extendPath: String {
        return ""
    }
    
    var baseURL: URL {
        return Constant.photoBaseUrl
    }
    
    var path: String {
        switch self {
        case .uploadAudio:
            return "/ajax/attachment/media.audio"
        case .uploadVideo:
            return "/ajax/attachment/media.video"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var parameters: [String: Any]? {
        return [:]
    }
    
    var task: Task {
        switch self {
        case .uploadAudio(let data):
            let data = MultipartFormData(provider: .data(data), name: "upl")
            return .uploadCompositeMultipart([data], urlParameters: ["thumbnail": "thumbnail"])
            
        case .uploadVideo(let data):
            let data = MultipartFormData(provider: .data(data), name: "upl")
            return .uploadCompositeMultipart([data], urlParameters: ["thumbnail": "thumbnail"])
        }
    }
    
    var headers: [String: String]? {
        return ["access_token": UserSessionManager.accessToken() ?? "",
                "device_id": DeviceManager.deviceID]
    }
}
