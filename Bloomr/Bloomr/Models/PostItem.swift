//
//  PostModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import SwiftyJSON
class PostItem: JSONParsable, PostItemProtocol {
    var type: ContestItemFormatType = .all
    var feed_id: String?
    
    required init?(json: JSON) {
        self.feed_id = json["feed_id"].stringValue
    }

}

struct UserPosts: UserPostItemProtocol {
    var postItems: [PostItem] = []
    
    var user: String? = ""
    
}
