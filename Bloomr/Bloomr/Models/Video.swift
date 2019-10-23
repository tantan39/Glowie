//
//  Video.swift
//  Bloomr
//
//  Created by Tan Tan on 10/11/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import SwiftyJSON
class Video: JSONParsable {
    var videoId: String?
    var videoUrl: String?
    required init?(json: JSON) {
        self.videoId = json["videoId"].stringValue
        self.videoUrl = json["videoUrl"].stringValue
    }
}
