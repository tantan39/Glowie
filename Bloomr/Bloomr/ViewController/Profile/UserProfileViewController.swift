//
//  UserProfileViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/18/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import Presentr
import IGListKit
import SVProgressHUD
class UserProfileViewController: BaseViewController {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .veryLightPinkTwo
        collectionView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.cellIdentifier())
        return collectionView
    }()
    
    lazy var remindNotificationPopup: RemindNotificationPopup = {
        let popup = RemindNotificationPopup(frame: .zero)
        popup.isHidden = true
        return popup
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    let presenter: Presentr = {
        let width = ModalSize.fluid(percentage: 0.7)
        let height = ModalSize.fluid(percentage: 0.4)
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .top
        return customPresenter
    }()
    
    var viewModel: MyProfileViewModel?
    
    convenience init(viewModel: MyProfileViewModel?) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel?.fetchUserProfile { [weak self] (_, error) in
            guard let self = self else { return }
            if let error = error {
                self.handle(error)
                return
            }
        }
        
        handleObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = .white
        
        setupCollectionView()
        setupRemindNotificationPopup()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        self.adapter.dataSource = self
        self.adapter.collectionView = self.collectionView
    }
    
    private func setupRemindNotificationPopup() {
        self.view.addSubview(self.remindNotificationPopup)
        self.remindNotificationPopup.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(50)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                maker.bottom.equalTo(self.bottomLayoutGuide.snp.top)
            }
        }
    }
    
    private func handleObservers() {
        self.viewModel?.isLoading.subscribe(onNext: { (loading) in
            if loading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.user.subscribe(onNext: { [weak self] (user) in
            guard let self = self, let _ = user else { return }
            self.adapter.reloadData(completion: nil)
            self.viewModel?.getActiveAlbumContest()
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.activeAlbumContest.subscribe(onNext: { [weak self] (albums) in
             guard let self = self, let albums = albums, albums.count > 0 else { return }
             if let section = self.listAdapter(self.adapter, sectionControllerFor: "availablecontests") as? JoiningContestSectionController {
                 section.albums = albums
                 self.adapter.reloadData(completion: nil)
             }
         }).disposed(by: self.disposeBag)
    }
    
}

// MARK: - ListAdapterDataSource
extension UserProfileViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.viewModel?.listAdaper ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let section = object as? String else { return ListSectionController() }
        if section == "profile" {
            return ProfileStatusSectionController(viewModel: self.viewModel, myProfile: false)
        } else if section == "interactive" {
            return ProfileInteractiveSectionController(viewModel: self.viewModel, isMyProfile: false)
        } else if section == "availablecontests" {
            return JoiningContestSectionController(albums: self.viewModel?.activeAlbumContest.value)
        } else {
            return ClosedContestSectionController(viewModel: self.viewModel)
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

// MARK: - UserProfileCoverHeaderViewDelegate
extension UserProfileViewController: UserProfileCoverHeaderViewDelegate {
    func share_didPressed() {
        
    }
    
    func backButton_didPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
