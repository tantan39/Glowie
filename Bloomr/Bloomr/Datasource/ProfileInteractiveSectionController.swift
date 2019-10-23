//
//  ProfileInteractiveSectionController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import IGListKit

class ProfileInteractiveSectionController: ListSectionController {
    var interactivePageMenuDatasource: [String] = ["Givers", "Receivers"]
    var user: User?
    var viewModel: MyProfileViewModel?
    var isMyProfile: Bool = true
    
    init(viewModel: MyProfileViewModel?, isMyProfile: Bool) {
        super.init()
        self.viewModel = viewModel
        self.user = self.viewModel?.user.value
        inset = UIEdgeInsets(top: 0, left: 0, bottom: Dimension.shared.smallVerticalMargin, right: 0)
        self.isMyProfile = isMyProfile
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let height: CGFloat = self.isMyProfile ? 250 : 200
        return CGSize(width: Dimension.shared.widthScreen, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if self.isMyProfile {
            let cell = collectionContext?.dequeueReusableCell(of: InteractiveUsersCell.self, for: self, at: index) as? InteractiveUsersCell
            if let user = self.user {
                cell?.bindingData(receiverFlower: user.received_flower, followers: user.followers, followings: user.followings)
                cell?.topInteractiveUsersView.dataSource = self.interactivePageMenuDatasource
            }
            cell?.delegate = self.viewController as? InteractiveUsersCellDelegate
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionContext?.dequeueReusableCell(of: UserProfileInteractiveUsersCell.self, for: self, at: index) as? UserProfileInteractiveUsersCell
            if let user = self.user {
                 cell?.bindingData(receiverFlower: user.received_flower, followers: user.followers, followings: user.followings)
                cell?.topInteractiveUsersView.dataSource = self.interactivePageMenuDatasource
            }
            cell?.delegate = self.viewController as? UserProfileInteractiveUsersCellDelegate
            return cell ?? UICollectionViewCell()
        }
        
    }
}
