//
//  ClosedContestSectionController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/6/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
class ClosedContestSectionController: ListSectionController {
    var user: User?
    var viewModel: MyProfileViewModel?
    
    init(viewModel: MyProfileViewModel?) {
        super.init()
        self.viewModel = viewModel
        
        inset = UIEdgeInsets(top: 0, left: 0, bottom: Dimension.shared.smallVerticalMargin, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: Dimension.shared.widthScreen, height: 220)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: ClosedContestSectionCell.self, for: self, at: index) as? ClosedContestSectionCell else {
            fatalError()
        }
        return cell
    }
}
