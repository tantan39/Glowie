//
//  Pagination.swift
//  Bloomr
//
//  Created by Tan Tan on 11/29/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
     "total":1,
     "current_page":1,
     "total_pages":1,
     "per_page":"10"
*/

/*
 "index" : 0,
 "limit" : 10
 */
open class Pagination: JSONParsable {
    public var index = 0
    public var limit = 0
    
    public required init?(json: JSON) {
        self.index = json["index"].intValue
        self.limit = json["limit"].intValue
    }
}
