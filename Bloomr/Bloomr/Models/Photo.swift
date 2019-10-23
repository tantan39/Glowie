//
//  Photo.swift
//  Bloomr
//
//  Created by Tan Tan on 9/24/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import SwiftyJSON
class Photo: JSONParsable {
    var id: String?
    var url: String?
    
    required init?(json: JSON) {
        self.id = json["photo_id"].stringValue
        self.url = json["photo_url"].stringValue
    }
}
