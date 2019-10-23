//
//  AvailableContest.swift
//  Bloomr
//
//  Created by Tan Tan on 9/18/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import SwiftyJSON

class AvailableContest: JSONParsable {
    var countryContests: [Contest] = []
    var locationContests: [Contest] = []
    var sponsorContests: [Contest] = []
    var themeContests: [Contest] = []
    var singingContests: [Contest] = []
    var hiddenFaceContests: [Contest] = []
    var modelingContests: [Contest] = []
    
    lazy var categories: [ContestItemType] = {
        var categories: [ContestItemType] = []
        if self.countryContests.count > 0 {
            categories.append(.country)
        }
        
        if self.locationContests.count > 0 {
            categories.append(.location)
        }
        
        if self.sponsorContests.count > 0 {
            categories.append(.sponsor)
        }
        
        if self.singingContests.count > 0 {
            categories.append(.singing)
        }
        
        if self.hiddenFaceContests.count > 0 {
            categories.append(.hidden_face)
        }

        if self.modelingContests.count > 0 {
            categories.append(.modeling)
        }
        
        return categories
    }()
    
    lazy var contests: [Contest] = {
        return self.countryContests + self.locationContests + self.sponsorContests + self.themeContests + self.singingContests + self.hiddenFaceContests + self.modelingContests
    }()
    
    required init?(json: JSON) {
        self.countryContests = json["country_contests"].arrayValue.compactMap({ Contest(json: $0 )})
        self.locationContests = json["location_contests"].arrayValue.compactMap({ Contest(json: $0 )})
        self.sponsorContests = json["sponsor_contests"].arrayValue.compactMap({ Contest(json: $0 )})
        self.themeContests = json["theme_contests"].arrayValue.compactMap({ Contest(json: $0 )})
        self.singingContests = json["singing_contests"].arrayValue.compactMap({ Contest(json: $0 )})
        self.hiddenFaceContests = json["hidden_singing_contests"].arrayValue.compactMap({ Contest(json: $0 )})
        self.modelingContests = json["model_contest"].arrayValue.compactMap({ Contest(json: $0 )})
    }
}
