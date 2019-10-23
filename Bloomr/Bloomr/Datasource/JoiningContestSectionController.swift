//
//  AvailableContestSectionController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/6/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import IGListKit
class JoiningContestSectionController: ListSectionController {
    var user: User?
    var albums: [UserAlbumContest]?
    
    init(albums: [UserAlbumContest]?) {
        super.init()
        self.albums = albums
        
        inset = UIEdgeInsets(top: 0, left: 0, bottom: Dimension.shared.smallVerticalMargin, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: Dimension.shared.widthScreen, height: 200)
    }
    
    override func numberOfItems() -> Int {
        return self.albums?.count ?? 0
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: JoiningContestCollectionViewCell.self, for: self, at: index) as? JoiningContestCollectionViewCell, let album = self.albums?[index] else {
            fatalError()
        }
        cell.bindingData(title: album.name, flower: album.flowers, posts: album.posts)
        cell.delegate = self.viewController as? JoiningContestCollectionViewCellDelegate
        return cell
    }
}
