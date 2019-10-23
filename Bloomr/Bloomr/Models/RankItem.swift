//
//  RankItem.swift
//  Bloomr
//
//  Created by Tan Tan on 9/21/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import SwiftyJSON

struct RankItem: JSONParsable {
    var displayName: String?
    var uid: Int?
    var userName: String?
    var rank: Int?
    var avatar: String?
    var flower: Int = 0
    var gsb: String?
    
    init?(json: JSON) {
        self.displayName = json["name"].stringValue
        self.uid = json["uid"].intValue
        self.rank = json["rank"].intValue
        self.userName = json["username"].stringValue
        self.avatar = json["avatar"].stringValue
        self.flower = json["flower"].intValue
    }
}
