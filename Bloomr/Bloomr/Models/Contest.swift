//
//  Contest.swift
//  Bloomr
//
//  Created by Tan Tan on 8/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import SwiftyJSON
enum ContestType: String {
    case main = "star"
    case singing = "singing"
    case modeling = "model"
}

class Contest: ContestItemProtocol, JSONParsable {
    var contestType: ContestItemType {
        get {
            return .contestType(self.category)
        }
        
    }

    var contestFormat: ContestItemFormatType {
        if self.contestType == .singing {
            return .audio
        } else if self.contestType == .modeling {
            return .video
        } else {
            return .photo
        }
    }
    
    var sectionTitle: String {
        get {
            return self.name ?? ""
        }
    }
    var key: String = ""
    var itemNumbers: Int = 1
    
    let categoryName: String?
    let infoURL: String?
    let name: String?
    var category: Int = 0
    var location_id: Int = 0
    var avatar: String = ""
    
    private var isJoin: Int = -1

    var joinContest: Bool {
        get {
            if isJoin == 2 || isJoin == 0 {
                return true
            }
            return false
        }
        set {
            isJoin = newValue ? 2 : 1
        }
    }

    required init?(json: JSON) {
        self.categoryName = json["category_name"].stringValue
        self.infoURL = json["race_info"].stringValue
        self.name = json["name"].stringValue
        self.category = json["category"].intValue
        self.location_id = json["location_id"].intValue
        self.key = json["key"].stringValue
        self.isJoin = json["isJoin"].intValue
        self.avatar = json["avatar"].stringValue
    }
}
