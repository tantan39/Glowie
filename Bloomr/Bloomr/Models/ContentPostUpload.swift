//
//  ContentPostUpload.swift
//  Bloomr
//
//  Created by Tan Tan on 9/26/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import SwiftyJSON
class ContentPostUpload: JSONParsable {
    var thumbnailImage: UIImage?
    var media_id: String?
    var photo: UIImage?
    var caption: String?
    var tags: [String]?
    var contentType: PostContentType?
    var title: String?
    
    required init?(json: JSON) {
        
    }
    
    convenience init?(thumbnail: UIImage?, media_id: String?, caption: String?, contest: String?, type: PostContentType?) {
        self.init(json: [:])
        
        self.thumbnailImage = thumbnail
        self.media_id = media_id
        self.caption = caption
        self.tags = [contest] as? [String]
        self.contentType = type
    }
    
    func export() -> JSON {
        var json = JSON()
        json["media_id"] = JSON(self.media_id ?? "")
        json["caption"] = JSON(self.caption ?? "")
        json["tags"] = [JSON(self.tags?.first ?? "")]
        return json
    }
}
