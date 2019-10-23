//
//  NotificationListViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/14/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
class NotificationListViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        collectionView.register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: NotificationCollectionViewCell.cellIdentifier())
        collectionView.backgroundColor = .veryLightPinkTwo
        collectionView.alwaysBounceVertical = true 
        return collectionView
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    let viewModel = NotificationListViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = TextManager.notificationText.localized().uppercased()
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
        setupCollectionView()
        
        self.handleObservers()
        
        self.viewModel.fetchNotification(index: 0, limit: 20, completion: nil)
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
    }
    
    private func handleObservers() {
        self.viewModel.dataSource.subscribe(onNext: { (data) in
            if let data = data {
                self.adapter.reloadData(completion: nil)
            }
        }).disposed(by: self.disposeBag)
    }
}

// MARK: - ListAdapterDataSource
extension NotificationListViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.viewModel.dataSource.value ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let noti = object as? NotificationItem else { return ListSectionController() }
        if noti.type == .comment {
            return NotificationSectionController()
        } else if noti.type == .tag {
            return NotificationSectionController()
        } else {
            return NotificationSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
