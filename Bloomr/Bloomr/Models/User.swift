//
//  User.swift
//  Bloomr
//
//  Created by Tan Tan on 9/4/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
import SwiftyJSON

class User: JSONParsable {
    var uid: Int?
    var gender: Int?
    var phoneNumber: String? = ""
    var userName: String? = ""
    var displayName: String? = ""
    var location: String? = ""
    var avatar: String? = ""
    var flowers: Int = 0
    var received_flower: Int = 0
    var isupload_avatar: Bool = false
    var followers: Int = 0
    var followings: Int = 0
    
    required init?(json: JSON) {
        self.uid = json["uid"].intValue
        self.displayName = json["name"].stringValue
        self.userName = json["username"].stringValue
        self.phoneNumber = json["mobile"].stringValue
        self.gender = json["gender"].intValue
        self.location = json["location"].stringValue
        self.avatar = json["avatar"].stringValue
        self.flowers = json["flowers"].intValue
        self.received_flower = json["received_flower"].intValue
        self.isupload_avatar = json["isupload_avatar"].boolValue
        self.followers = json["follower"].intValue
        self.followings = json["following"].intValue
    }    
}

extension User: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.uid as NSObjectProtocol? ?? "" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? User else { return false }
        return self.uid == object.uid
    }
}
