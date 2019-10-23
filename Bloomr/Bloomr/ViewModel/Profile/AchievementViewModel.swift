//
//  AchievementViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 9/13/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift
import IGListKit

class JoinedCcntest: NSObject,ListDiffable {
    var name: String?
    
    init(name: String?) {
        super.init()
        self.name = name
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self.name as NSObjectProtocol? ?? "" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? JoinedCcntest else { return false }
        return self.name == object.name
    }
    
}

class AchievementViewModel: BaseViewModel {
    var joinedContest = BehaviorRelay<[String]>(value: [])
    
    func listAdaper() -> [ListDiffable] {
        
        let vnContest = JoinedCcntest(name: "VietNam")
        let shinhanbank = JoinedCcntest(name: "Shinhan")
        return [vnContest, shinhanbank]
    }
}
