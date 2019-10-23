//
//  AchievementLocationContestSectionController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/14/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
class AchievementLocationContestSectionController: ListSectionController {
    
    override init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: Dimension.shared.smallVerticalMargin, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: Dimension.shared.widthScreen, height: 200 + (Dimension.shared.widthScreen * 9/16))
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: AchievementLocationContestCell.self, for: self, at: index) as? AchievementLocationContestCell else {
            fatalError()
        }
        return cell
    }
}
