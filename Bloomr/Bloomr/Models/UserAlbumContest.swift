//
//  UserAlbumContest.swift
//  Bloomr
//
//  Created by Tan Tan on 9/30/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import SwiftyJSON
class UserAlbumContest: JSONParsable {
    var status_name: String?
    var name: String?
    var key: String?
    var posts: [GalleryThumbnail]?
    var flowers: Int = 0
    
    required init?(json: JSON) {
        self.status_name = json["status_name"].stringValue
        self.name = json["name"].stringValue
        self.key = json["key"].stringValue
        self.flowers = json["flower_onrace"].intValue
    }
}
