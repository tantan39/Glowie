//
//  Audio.swift
//  Bloomr
//
//  Created by Tan Tan on 10/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import SwiftyJSON
class Audio: JSONParsable {
    var audioId: String?
    var audioUrl: String?
    required init?(json: JSON) {
        self.audioId = json["audioId"].stringValue
        self.audioUrl = json["audioUrl"].stringValue
    }
}
