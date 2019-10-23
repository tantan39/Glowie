//
//  ContestItemProtocol.swift
//  Bloomr
//
//  Created by Tan Tan on 8/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//

enum Gender: Int {
    case female
    case male
    case none
    
    public func toInt() -> Int {
        if self == .female {
            return 0
        }
        if self == .male {
            return 1
        }
        return -1
    }
}

enum ContestItemType {
    // location 1: HCM
    // location 2: HN
    case country
    case location
    case theme
    case sponsor
    case event
    case singing
    case hidden_face
    case modeling
    
    static func contestType(_ category: Int) -> ContestItemType {
        if category == 1 {
            return .country
        } else if category == 2 {
            return .location
        } else if category == 3 {
            return .theme
        } else if category == 4 {
            return .sponsor
        } else if category == 5 {
            return .event
        } else if category == 6 {
            return .singing
        } else if category == 7 {
            return .hidden_face
        } else {
            return .modeling
        }
    }
}

extension ContestItemType: Equatable {
    public static func == (lhs: ContestItemType, rhs: ContestItemType) -> Bool {
        switch (lhs, rhs) {
        case (.country, .country):
            return true
        case (.theme, .theme):
            return true
        case (.sponsor, .sponsor):
            return true
        case (.location, .location):
            return true
        case (.singing, .singing):
            return true
        case (.hidden_face, .hidden_face):
            return true
        case (.modeling, .modeling):
            return true
        default:
            return false
        }
        
    }
}

enum ContestItemFormatType {
    case photo
    case audio
    case video
    case all
}

protocol ContestItemProtocol {
    var contestType: ContestItemType { get }
    var contestFormat: ContestItemFormatType { get }
    var sectionTitle: String { get }
    var itemNumbers: Int { get }
    var key: String { get }
    var avatar: String { get }
}
