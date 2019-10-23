//
//  PostProfile.swift
//  Bloomr
//
//  Created by Tan Tan on 10/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import SwiftyJSON
class PostProfile: JSONParsable {
    var name: String?
    var username: String?
    var isShare: Bool = false
    var isFollow: Bool = false
    var uid: Int?
    var avatar: String?
    
    required init?(json: JSON) {
        self.name = json["name"].stringValue
        self.username = json["username"].stringValue
        self.isShare = json["is_share"].boolValue
        self.isFollow = json["is_follow"].boolValue
        self.uid = json["uid"].intValue
        self.avatar = json["avatar"].stringValue
    }
}
