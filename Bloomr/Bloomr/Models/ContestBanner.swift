//
//  ContestBanner.swift
//  Bloomr
//
//  Created by Tan Tan on 9/21/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import SwiftyJSON
struct ContestBanner: JSONParsable {
    let uid: Int
    let photo_id: String?
    let rank: Int?
    let photo_url: String?
    
    init?(json: JSON) {
        self.uid = json["uid"].intValue
        self.photo_id = json["photo_id"].stringValue
        self.rank = json["rank"].intValue
        self.photo_url = json["photo_url"].stringValue
    }
}
