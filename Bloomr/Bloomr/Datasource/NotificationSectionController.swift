//
//  NotificationSectionController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
class NotificationSectionController: ListSectionController {
    var item: NotificationItem?
    override init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: Dimension.shared.normalVerticalMargin, right: 0)
        self.minimumLineSpacing = Dimension.shared.normalVerticalMargin
        self.minimumInteritemSpacing = Dimension.shared.normalVerticalMargin
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: Dimension.shared.widthScreen, height: 60)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func didUpdate(to object: Any) {
        guard let noti = object as? NotificationItem else { return }
        self.item = noti
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: NotificationCollectionViewCell.self, for: self, at: index) as? NotificationCollectionViewCell else { fatalError() }
        cell.setValue(message: self.item?.message)
        return cell
    }
}
