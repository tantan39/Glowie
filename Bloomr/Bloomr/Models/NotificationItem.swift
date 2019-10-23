//
//  File.swift
//  Bloomr
//
//  Created by Tan Tan on 9/14/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
import SwiftyJSON
enum NotificationType {
    case receivedFlower
    case tag
    case comment
}

class NotificationItem: JSONParsable, ListDiffable {
    var message: String?
    var type: NotificationType?
    var _type: String?
    var notification_id: String?
    
    required init?(json: JSON) {
        self.message = json["message"].stringValue
        self.notification_id = json["notification_id"].stringValue
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self.notification_id! as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NotificationItem else { return false }
        return object.type == self.type
    }
    
}
