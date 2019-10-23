//
//  SettingItem.swift
//  Bloomr
//
//  Created by Tan Tan on 9/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
enum SettingTyoe {
    case account
    case privacy
    case application
    case intro
    case none
}

class SettingItem: NSObject, ListDiffable {
    var title: String = ""
    var type: SettingTyoe = .none
    
    convenience init(title: String, type: SettingTyoe) {
        self.init()
        self.title = title
        self.type = type
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self.title as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? SettingItem else { return false }
        return self.title == object.title
    }
}
