//
//  ProfileDescriptionSectionController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/4/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit

class ProfileStatusSectionController: ListSectionController, ListSupplementaryViewSource {
    
    var isMyProfile: Bool = true
    var viewModel: MyProfileViewModel?
    
    override init() {
        super.init()
        self.supplementaryViewSource = self
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: Dimension.shared.smallVerticalMargin, right: 0)
    }
    
    convenience init(viewModel: MyProfileViewModel?, myProfile: Bool) {
        self.init()
        self.viewModel = viewModel
        self.isMyProfile = myProfile
    }
    
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        return self.coverHeaderView(atIndex: index)
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: Dimension.shared.widthScreen, height: Dimension.shared.widthScreen * 3/4)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: Dimension.shared.widthScreen, height: 250)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: ProfileStatusCollectionViewCell.self, for: self, at: index) as? ProfileStatusCollectionViewCell else {
            fatalError()
        }
        if let user = self.viewModel?.user.value {
            cell.binding(user)
        }
        cell.delegate = self.viewController as? ProfileStatusCollectionViewCellDelegate
        return cell
    }
}

extension ProfileStatusSectionController {
    private func coverHeaderView(atIndex index: Int) -> UICollectionReusableView {
        if !isMyProfile {
            guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: self, class: UserProfileCoverHeaderView.self, at: index) as? UserProfileCoverHeaderView else { fatalError() }
            view.delegate = self.viewController as? UserProfileCoverHeaderViewDelegate
            return view
        } else {
            guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: self, class: ProfileCoverHeaderView.self, at: index) as? ProfileCoverHeaderView else { fatalError() }
            view.delegate = self.viewController as? ProfileCoverHeaderViewDelegate
            return view
        }
    }
}
