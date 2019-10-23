//
//  SettingViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
class SettingViewController: BaseViewController {
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(SettingItemCell.self, forCellWithReuseIdentifier: SettingItemCell.cellIdentifier())
        collectionView.backgroundColor = .veryLightPinkTwo
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = TextManager.settingText.localized().uppercased()
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = .veryLightPinkTwo

        setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            }
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
//        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
//        }
        
        self.adapter.dataSource = self
        self.adapter.collectionView = self.collectionView
    }
}

extension SettingViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
//        let sections = [
//            SettingItem(title: TextManager.profileText, type: .account),
//            SettingItem(title: TextManager.changePasswordText, type: .account),
//            SettingItem(title: TextManager.settingText, type: .privacy),
//            SettingItem(title: TextManager.blockListText, type: .privacy),
//            SettingItem(title: TextManager.languageText, type: .application),
//            SettingItem(title: TextManager.notificationText, type: .application),
//            SettingItem(title: TextManager.faqText, type: .intro),
//            SettingItem(title: TextManager.communityText, type: .intro),
//            SettingItem(title: TextManager.tempConditionText, type: .intro)
//        ]
        let sections = [TextManager.informationAccountText, TextManager.privacyText, TextManager.settingAppText, TextManager.introduceText]
        return sections as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        guard let item = object as? String else { return ListSectionController() }
        if item == TextManager.informationAccountText {
            return InformationSectionController()
        } else if item == TextManager.privacyText {
            return PrivacySectionController()
        } else if item == TextManager.settingAppText {
            return SettingAppSectionController()
        } else {
            return IntroduceSectionController()
        }
//        switch item.type {
//        case .account:
//            return InformationSectionController()
//        case .privacy:
//            return PrivacySectionController()
//        case .application:
//            return SettingAppSectionController()
//        default:
//            return IntroduceSectionController()
//        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
