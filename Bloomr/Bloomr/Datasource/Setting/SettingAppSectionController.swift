//
//  SettingAppSectionController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
class SettingAppSectionController: ListSectionController, ListSupplementaryViewSource {
    lazy var titleHeader: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.fromType(.primary(.bold, .h1))
        label.textColor = UIColor.charcoal_grey
        label.text = TextManager.settingAppText.localized()
        return label
    }()
    
    var items = [
        SettingItem(title: TextManager.languageText.localized(), type: .account),
        SettingItem(title: TextManager.notificationText.localized(), type: .account)
    ]
    
    override init() {
        super.init()
        self.supplementaryViewSource = self
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
    }
    
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: self, class: UICollectionReusableView.self, at: index) else { fatalError() }
        view.backgroundColor = .white
        view.addSubview(self.titleHeader)
        titleHeader.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.centerY.equalToSuperview()
        }
        
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: Dimension.shared.widthScreen, height: 40)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: Dimension.shared.widthScreen, height: 40)
    }

    override func numberOfItems() -> Int {
        return items.count
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SettingItemCell.self, for: self, at: index) as? SettingItemCell else { fatalError() }
        cell.title.text = items[index].title
        return cell
    }
}
