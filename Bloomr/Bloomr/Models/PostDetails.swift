//
//  PostDetails.swift
//  Bloomr
//
//  Created by Tan Tan on 10/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import SwiftyJSON
class PostDetails: JSONParsable {
    var profile: PostProfile?
    var flower: Int = 0
    var photoUrl: String?
    var post_id: String?
    var tags: [Any]?
    var photo_id: String?
    var photoUrl_full: String?
    var caption: String?
    var timestamp: TimeInterval = 0
    var comments: Any?
    
    required init?(json: JSON) {
        self.profile = PostProfile(json: json["profile"])
        
        let content = json["content"]
        self.flower = content["flower"].intValue
        self.photoUrl = content["photo_url"].stringValue
        self.post_id = content["post_id"].stringValue
        self.tags = content["tags"].arrayValue
        self.photo_id = content["photo_id"].stringValue
        self.photoUrl_full = content["photo_url_full"].stringValue
        self.caption = content["caption"].stringValue
        self.timestamp = content["timestamp"].doubleValue
        self.comments = content["comments"].dictionaryValue
    }
}
