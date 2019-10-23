//
//  PostDetailsViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/24/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import Pulley
import AVFoundation

class PostShowsViewController: BaseViewController {
    
    lazy var navigationView: NavigationBarCustomView = {
        let view = NavigationBarCustomView(frame: .zero)
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Dimension.shared.widthScreen, height: self.view.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.cellIdentifier())
        collectionView.register(PhotoPostCell.self, forCellWithReuseIdentifier: PhotoPostCell.cellIdentifier())
        collectionView.register(AudioPostCell.self, forCellWithReuseIdentifier: AudioPostCell.cellIdentifier())
        collectionView.register(VideoPostCell.self, forCellWithReuseIdentifier: VideoPostCell.cellIdentifier())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var playerControls: PlayerControlsCustomView = {
        let view = PlayerControlsCustomView(frame: .zero)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    var viewModel: PostShowsViewModel?
    let playerControlsBottomPadding: CGFloat = Dimension.shared.mediumVerticalMargin
    
    convenience init(viewModel: PostShowsViewModel?) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let selectedPost = self.viewModel?.presentingPost.value, let index = self.viewModel?.dataSouce.value?.firstIndex(where: { $0.post_id ==  selectedPost.post_id }) {
            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.viewModel?.mediaManager?.pause()
        self.viewModel?.isPauseMedia.accept(true)
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupCollectionView()
        setupNavigationView()
        setupPlayerControlsView()
        
        handleObservers()
    }
    
    private func setupNavigationView() {
        self.view.addSubview(self.navigationView)
        self.navigationView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            maker.height.equalTo(40)
        }
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupPlayerControlsView() {
        self.view.addSubview(playerControls)
        self.playerControls.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func handleObservers() {
        self.navigationView.backButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.navigationView.settingButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            AppManager.shared.showActionSheet(title: nil, itemsTitle: [TextManager.saveText, TextManager.reportText], cancelTitle: TextManager.cancelText, completion: nil, selectedIndex: { index in
                let reportPopup = ReportPopup()
                reportPopup.show()
            })
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.dataSouce.subscribe(onNext: { [weak self] (dataSource) in
            guard let self = self, let _ = dataSource else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        self.playerControls.playButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self, let viewModel = self.viewModel else { return }
            if viewModel.isPauseMedia.value {
                viewModel.mediaManager?.play()
            } else {
                viewModel.mediaManager?.pause()
            }
            
            viewModel.isPauseMedia.accept(!viewModel.isPauseMedia.value)
        }).disposed(by: self.disposeBag)
        
        self.playerControls.previousButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {  [weak self] (_) in
            guard let self = self, let index = self.collectionView.indexPathsForVisibleItems.first else { return }
            let prevIndex = IndexPath(row: index.row - 1, section: index.section)
            self.collectionView.scrollToItem(at: prevIndex, at: .centeredHorizontally, animated: true)
            
        }).disposed(by: self.disposeBag)
        
        self.playerControls.nextButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {  [weak self] (_) in
            guard let self = self, let index = self.collectionView.indexPathsForVisibleItems.first else { return }
            let nextIndex = IndexPath(row: index.row + 1, section: index.section)
            self.collectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
            
        }).disposed(by: self.disposeBag)
        
        self.playerControls.speakerButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {  [weak self] (_) in
            guard let self = self, let viewModel = self.viewModel else { return }
            viewModel.isOffSpeaker.accept(!viewModel.isOffSpeaker.value)
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.isOffSpeaker.subscribe(onNext: {  [weak self] (speaker) in
            self?.viewModel?.setAudioOutputSpeaker(speaker)
            self?.playerControls.updateSpeakerStatus(speaker)
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.isPauseMedia.subscribe(onNext: {  [weak self] (pause) in
            self?.playerControls.updateStatus(pause)
        }).disposed(by: self.disposeBag)
        
//        self.viewModel?.presentingPost.subscribe(onNext: { [weak self] (post) in
//            guard let self = self, let _ = post else { return }
//            self.viewModel?.getPostDetail(postID: post?.post_id, completion: { ( _, error) in
//
//            })
//        }).disposed(by: self.disposeBag)
        
        self.viewModel?.nextItem.skip(1).subscribe(onNext: { [weak self] (post) in
            guard let self = self, let _ = post else { return }
            self.viewModel?.getPostDetail(postID: post?.post_id, completion: { ( _, error) in
                if let pulleyViewController = self.pulleyViewController, let secondaryViewController = pulleyViewController.drawerContentViewController as? PostContentViewController {
                    
                }
            })
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.postDetails.subscribe(onNext: { [weak self] (postDetail) in
            guard let self = self else { return }
            if let post = postDetail, let index = self.viewModel?.dataSouce.value?.firstIndex(where: { $0.post_id == post.post_id }) {
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoPostCell {
                    cell.binding(photoUrl: post.photoUrl_full)
                }
            }
        }).disposed(by: self.disposeBag)
    }
}

extension PostShowsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModel?.mediaManager?.pause()
        self.viewModel?.isPauseMedia.accept(true)
//        guard let post = self.viewModel?.userPosts?[indexPath.section].postItems[indexPath.row] else { return }
        guard let post = self.viewModel?.dataSouce.value?[indexPath.row] else { return }
        self.viewModel?.nextItem.accept(post)
        logDebug("willDisplay \(post.type)")
        let mediaType = post.type
        if mediaType == .audio {
            self.viewModel?.configMediaManger(type: .audio, url: post.audioURL)
        } else if mediaType == .video {
            self.viewModel?.configMediaManger(type: .video, url: post.videoURL)
            if let videoCell = cell as? VideoPostCell {
                let playerLayer = AVPlayerLayer(player: self.viewModel?.mediaManager?.player)
                playerLayer.frame = videoCell.frame
                videoCell.layer.addSublayer(playerLayer)
            }
        }
        let enablePlayButton = (mediaType == .audio) || (mediaType == .video)
        self.playerControls.enablePlayerControl(enablePlayButton)
        self.playerControls.setIndex(index: indexPath.row + 1, total: self.viewModel?.total ?? 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.viewModel?.userPosts?[section].postItems.count ?? 0
        return self.viewModel?.dataSouce.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let post = self.viewModel?.userPosts?[indexPath.section].postItems[indexPath.row]
        guard let post = self.viewModel?.dataSouce.value?[indexPath.row] else { return UICollectionViewCell() }
        switch post.type {
        case .audio:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioPostCell.cellIdentifier(), for: indexPath) as? AudioPostCell
            cell?.draggableLocation.delegate = self
            return cell ?? UICollectionViewCell()
        case .video:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoPostCell.cellIdentifier(), for: indexPath) as? VideoPostCell
            cell?.draggableLocation.delegate = self
            return cell ?? UICollectionViewCell()
        case .photo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPostCell.cellIdentifier(), for: indexPath) as? PhotoPostCell
            cell?.draggableLocation.delegate = self
            return cell ?? UICollectionViewCell()
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.cellIdentifier(), for: indexPath)
            return cell
        }
    }
}

extension PostShowsViewController: PulleyPrimaryContentControllerDelegate {
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        self.playerControls.snp.updateConstraints { (maker) in
            maker.bottom.equalToSuperview().offset( -distance - playerControlsBottomPadding )
        }
    }
}

extension PostShowsViewController: SEDraggableLocationEventResponder {
    func draggableLocation(_ location: SEDraggableLocation!, didAcceptObject object: SEDraggable!, entryMethod method: SEDraggableLocationEntryMethod) {
        AppManager.showExpandingMenu(from: location, style: .cell, homeSelected: {
            
        }, valueSelected: { (index) in
            
        }, storeSelected: {
            
        })
//        AppManager.showExpandingMenu(from: location, style: .cell ) { (_) in
//            AppManager.showAfterEffect(from: location, style: .cell )
//        }
    }
}
