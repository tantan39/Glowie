//
//  GalleryThumbnail.swift
//  Bloomr
//
//  Created by Tan Tan on 9/30/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import SwiftyJSON
class GalleryThumbnail: JSONParsable {
    var photoURL: String?
    var audioURL: String?
    var videoURL: String?
    var post_id: String?
    var is_avatar: Bool = false
    var caption: String?
    var flower: Int = 0
    var timestamnp: Double
    var _type: Int?
    
    required init?(json: JSON) {
        self.audioURL = json["audio_url"].stringValue
        self.photoURL = json["photo_url_n"].stringValue
        self.videoURL = json["video_url"].stringValue
        self.post_id = json["post_id"].stringValue
        self.is_avatar = json["is_avatar"].boolValue
        self.caption = json["caption"].stringValue
        self.flower = json["flower"].intValue
        self.timestamnp = json["timestamp"].doubleValue
        self._type = json["type"].intValue
    }
}

extension GalleryThumbnail: PostItemProtocol {
    var type: ContestItemFormatType {
        if self._type == 0 {
            return .photo
        } else if self._type == 1 {
            return .audio
        } else {
            return .video
        }
    }
}
