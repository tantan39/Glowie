//
//  AchievementViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/13/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
class AchievementViewController: BaseViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.cellIdentifier())
        collectionView.register(JoiningContestCollectionViewCell.self, forCellWithReuseIdentifier: JoiningContestCollectionViewCell.cellIdentifier())
        collectionView.backgroundColor = .veryLightPinkTwo
//        collectionView.dataSource = self
//        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    let viewModel = AchievementViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = TextManager.achievementText.localized().uppercased()
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
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
        self.adapter.dataSource = self
        self.adapter.collectionView = self.collectionView

//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            let padding: CGFloat = 3.0
//            let column = 3
//            layout.minimumLineSpacing = padding
//            layout.minimumInteritemSpacing = padding
//            layout.scrollDirection = .vertical
//            let widthItem =  (self.view.width - (padding * 2)) / CGFloat(column)
//            layout.itemSize = CGSize(width: Dimension.shared.widthScreen, height: 240)
//
//        }
    }
}

// MARK: - ListAdapterDataSource
extension AchievementViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.viewModel.listAdaper()
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let contest = object as? JoinedCcntest else { return ListSectionController() }
        if contest.name == "VietNam" {
            return AchievementLocationContestSectionController()
        } else {
            return AchievementContestSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
//extension AchievementViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JoiningContestCollectionViewCell.cellIdentifier(), for: indexPath) as? JoiningContestCollectionViewCell else { return UICollectionViewCell() }
//
//        return cell
//    }
//}
