//
//  MyProfileViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/4/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
import Presentr
class MyProfileViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .veryLightPinkTwo
        collectionView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = MyProfileViewModel()
        self.viewModel?.user.accept(UserSessionManager.user())
        
        self.adapter.reloadData(completion: nil)
        
        self.viewModel?.getActiveAlbumContest()
        handleObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
        self.viewModel?.user.subscribe(onNext: { [weak self] (user) in
            guard let self = self, let _ = user else { return }
            self.adapter.reloadData(completion: nil)
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
extension MyProfileViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.viewModel?.listAdaper ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let section = object as? String else { return ListSectionController() }
        if section == "profile" {
            return ProfileStatusSectionController(viewModel: self.viewModel, myProfile: true)
        } else if section == "interactive" {
            return ProfileInteractiveSectionController(viewModel: self.viewModel, isMyProfile: true)
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

// MARK: - ProfileCoverHeaderViewDelegate
extension MyProfileViewController: ProfileCoverHeaderViewDelegate {
    func uploadCoverButton_didPressed() {
//        showUpdateInfoPopup()
        _ = EditCoverRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
    }
    
    func notificationButton_didPressed() {
        _ = NotificationListRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
    }
    
    func settingButton_didPressed() {
        _ = SettingRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
    }
}

// MARK: - ProfileStatusCollectionViewCellDelegate
extension MyProfileViewController: ProfileStatusCollectionViewCellDelegate {
    func editAvatarButton_didPressed() {
        _ = EditAvatarRouter(edit: .avatar).navigate(from: self.navigationController, transitionType: .push, animated: true)
    }
}

// MARK: - InteractiveUsersCellDelegate
extension MyProfileViewController: InteractiveUsersCellDelegate {
    func uploadButton_didPressed() {
        _ = AvailableContestsRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
    }
    
    func achievementButton_didPressed() {
        _ = AchievementRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
    }
    
    func viewMoreInteractiveButton_didPressed() {
        _ = InteractiveUserListRouter().navigate(from: self.navigationController, transitionType: .push, animated: true, completion: nil)
    }
    
    func flowerShopButton_didPressed() {
        _ = FlowerShopRouter().navigate(from: self.navigationController, transitionType: .push, animated: true, completion: nil)
    }
}

// MARK: - JoiningContestCollectionViewCellDelegate
extension MyProfileViewController:  JoiningContestCollectionViewCellDelegate {
    func didSelectedPostThumbnail(item: GalleryThumbnail?, at index: IndexPath?, postList: [GalleryThumbnail]?) {
        guard let post = item, let _ = index, let datasouce = postList else { return }
        _ = PostShowsRouter(data: datasouce, selectedItem: post).navigate(from: self.navigationController, transitionType: .push, animated: true)
    }
}

// MARK: - Support Method
extension MyProfileViewController {
    private func showUpdateInfoPopup() {
        let popup = RequireUpdateInfoViewController()
        customPresentViewController(self.presenter, viewController: popup, animated: true)
    }
    
}
