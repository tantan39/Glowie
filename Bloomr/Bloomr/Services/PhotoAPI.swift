//
//  PhotoAPI.swift
//  Bloomr
//
//  Created by Tan Tan on 9/24/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Foundation
import Moya

let PhotoAPIProvider = MoyaProvider<PhotoAPI>(endpointClosure: ServiceHelper.defaultEndpointClosure, manager: DefaultAlamofireManager.sharedManager, plugins: [MoyaLoggerPlugin])

enum PhotoAPI {
    case uploadAvatar(image: UIImage, contest: String)
    case uploadPhoto(image: UIImage)
}

extension PhotoAPI: TargetTypeHelper {
    var extendPath: String {
        return ""
    }
    
    var baseURL: URL {
        return Constant.photoBaseUrl
    }
    
    var path: String {
        switch self {
        case .uploadAvatar( _, _):
            return "/ajax/attachment/media.avatar"
        case .uploadPhoto( _):
            return "/ajax/attachment/media.photo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadAvatar( _, _):
            return .post
        case .uploadPhoto( _):
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var parameters: [String: Any]? {
//        switch self {
//        case .uploadAvatar( _, let contest):
//            return ["key": contest]
//        default:
            return [:]
//        }
    }
    
    var task: Task {
        switch self {
        case .uploadAvatar(let image, let contest):
            let imageData = UIImage.jpegData(image)(compressionQuality: 1.0)!
            let data = MultipartFormData(provider: .data(imageData), name: "upl")
            let key = MultipartFormData(provider: .data(contest.data(using: .utf8)!), name: "key")

//            return .uploadCompositeMultipart([data], urlParameters: ["key": key])
            return .uploadMultipart([data, key])
            
        case .uploadPhoto(let image):
            let imageData = UIImage.jpegData(image)(compressionQuality: 1.0)!
            let data = MultipartFormData(provider: .data(imageData), name: "upl")
            return .uploadMultipart([data])
        }
    }

    var headers: [String: String]? {
        return ["access_token": UserSessionManager.accessToken() ?? "",
                "device_id": DeviceManager.deviceID]
    }

}
