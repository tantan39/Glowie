//
//  SampleAPI.swift
//  Bloomr
//
//  Created by Tan Tan on 8/4/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Foundation
import Moya

let ContestAPIProvider = MoyaProvider<ContestAPI>(endpointClosure: ServiceHelper.defaultEndpointClosure, manager: DefaultAlamofireManager.sharedManager, plugins: [MoyaLoggerPlugin])

enum ContestAPI {
    case getAvailableContests(gender: Int, type: String)
    case joinRace(key: String, media_id: String)
    case getListRanking(contest: String, gender: Int, ckey: String?)
    case getContestBanners(contest: String, gender: Int, ckey: String?)
    case getAlbumContest(contest: String, gender: Int, index: Int, limit: Int)
    case getUserActiveGalleries(uid: Int?)
    case getUserPost(contest: String?, uid: Int?, index: Int, limit: Int)
}

extension ContestAPI: TargetTypeHelper {
    var extendPath: String {
        return "extend"
    }
    
    var baseURL: URL {
        return Constant.apiBaseUrl
    }
    
    var path: String {
        switch self {
        case .getAvailableContests(_, _):
            return "/api/racename.get.active"
        case .joinRace:
            return "/api/race.join"
        case .getListRanking(_, _, _):
            return "/api/race.get"
        case .getContestBanners(_, _, _):
            return "/api/race.banner.load"
        case .getAlbumContest( _, _, _, _):
            return "/api/gallery.race.get"
        case .getUserActiveGalleries( _):
            return "/api/galleries.get"
        case .getUserPost( _, _, _, _):
            return "/api/gallery.get"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .getAvailableContests(_, _):
            return .get
        case .getListRanking(_, _, _):
            return .get
        case .joinRace(_, _):
            return .post
        case .getContestBanners(_, _, _):
            return .get
        case .getAlbumContest( _, _, _, _):
            return .get
        case .getUserActiveGalleries( _):
            return .get
        case .getUserPost( _, _, _, _):
            return .get
        }
    }
    
    var sampleData: Data {
        return "No caption".data(using: .utf8)!
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAvailableContests(let gender, let type):
            return ["gender": gender,
                    "type": type
            ]
        case .joinRace(let key, let media_id):
            return ["key": key,
                    "media_id": media_id
            ]
        case .getListRanking(let contest, let gender, let ckey):
            var params: [String: Any] = ["key": contest,
                          "gender": gender,
                          "is_refresh": true
            ]
            if let ckey = ckey {
                params.updateValue(ckey, forKey: "ckey")
            }
            
            return params
        case .getContestBanners(let contest, let gender, let ckey):
            var params: [String: Any] = ["key": contest,
                                         "gender": gender
            ]
            if let ckey = ckey {
                params.updateValue(ckey, forKey: "ckey")
            }
            return params
            
        case .getAlbumContest(let contest, let gender, let index, let limit):
            return ["key": contest,
                    "gender": gender,
                    "index": index,
                    "linit": limit
            ]
         
        case .getUserActiveGalleries(let uid):
            if let uid = uid {
                return ["user_id": uid]
            }
            return [:]
            
        case .getUserPost(let contest, let uid, let index, let limit):
            return ["key": contest ?? "",
                    "user_id": uid ?? 0,
                    "index": index,
                    "linit": limit
            ]
        }
    }

    var headers: [String: String]? {
        return ["access_token": UserSessionManager.accessToken() ?? "",
                    "device_id": DeviceManager.deviceID]
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
