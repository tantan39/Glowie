//
//  ContestAlbumViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ContestAlbumViewController: BaseViewController, GiveFlowerAble {
    var droppableLocations: [SEDraggableLocation]? = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: AlbumCollectionViewLayout())
        collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier())
        collectionView.register(AudioAlbumCollectionViewCell.self, forCellWithReuseIdentifier: AudioAlbumCollectionViewCell.cellIdentifier())
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let popup: PopupPostView = {
        let popup = PopupPostView(frame: UIScreen.main.bounds)
        return popup
    }()
    var documentManager: DocumentManager?
    var viewModel: ContestAlbumViewModel = ContestAlbumViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.showNavigationBarRightViewStyle(.upload)
        self.title = self.viewModel.contest?.name
        
        handleObservers()
        
        self.viewModel.getAlbumContest { [weak self] (_, error) in
            guard let self = self, let err = error else { return }
            self.handle(err)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        AppManager.shared.homeTabBarView?.homeDraggable.removeAllAllowedDropLocations()
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
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
    }
    
    private func handleObservers() {
        self.popup.closeButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.popup.removeFromSuperview()
            AppManager.collapseMenu()
        }).disposed(by: self.disposeBag)
        
        self.popup.commentButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.popup.removeFromSuperview()
            AppManager.collapseMenu()
            _ = DetailStatusRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
        }).disposed(by: self.disposeBag)
        
        self.customNavigationView?.uploadButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            if self.viewModel.contest?.contestFormat == .audio {
                self.documentManager = DocumentManager()
                self.documentManager?.delegate = self
                self.documentManager?.openDocumentPickerViewController(from: self)
            } else {
                _ = DeviceGalleryRouter().navigate(from: self, transitionType: .present, animated: true)
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel.dataSouce.subscribe(onNext: { [weak self] (datasource) in
            guard let self = self, let album = datasource else { return }
//            var indexs: [IndexPath] = []
//            for (index, _) in album.enumerated() {
//                indexs.append(IndexPath(row: index, section: 0))
//            }
//            self.collectionView.insertItems(at: indexs)
            
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        self.viewModel.seletecPost.subscribe(onNext: { (post) in
            guard let _ = post else { return }
            _ = PostShowsRouter(data: self.viewModel.dataSouce.value, selectedItem: post).navigate(from: self.navigationController, transitionType: .push, animated: true)
        }).disposed(by: self.disposeBag)
        
    }
}

extension ContestAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSouce.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let datasouce = self.viewModel.dataSouce.value, indexPath.row == datasouce.count - 1 {
            self.viewModel.getAlbumContest(completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let object = self.viewModel.dataSouce.value?[indexPath.row] else { return UICollectionViewCell() }
        switch object.type {
        case .audio:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioAlbumCollectionViewCell.cellIdentifier(), for: indexPath) as? AudioAlbumCollectionViewCell
            cell?.draggableLocation.delegate = self

            return cell ?? UICollectionViewCell()
        case .photo:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier(), for: indexPath) as? ThumbnailCollectionViewCell else { return UICollectionViewCell() }
            cell.bindingData(imageUrl: object.photoURL)
            cell.playButton.isHidden = true
            cell.draggableLocation.delegate = self
            self.droppableLocations?.append(cell.draggableLocation)
            return cell
        case .video:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier(), for: indexPath) as? ThumbnailCollectionViewCell
            cell?.playButton.isHidden = false
            cell?.draggableLocation.delegate = self
            return cell ?? UICollectionViewCell()
        default:
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let thumbnail = self.viewModel.dataSouce.value?[indexPath.row] else { return }
        self.viewModel.seletecPost.accept(thumbnail)
    }
}

extension ContestAlbumViewController: SEDraggableLocationEventResponder {
    func draggableLocation(_ location: SEDraggableLocation!, didAcceptObject object: SEDraggable!, entryMethod method: SEDraggableLocationEntryMethod) {
        
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            rootVC.view.addSubview(popup)
            popup.layoutIfNeeded()
            
            AppManager.showExpandingMenu(from: popup.mainView, style: .postPopup, homeSelected: {
                self.showCustomFlowerPopup(completion: { [weak self] value in
                    guard let self = self else { return }
                    self.giveFlowers(value, location)
                })
            }, valueSelected: { (index) in
                
            }, storeSelected: {
                
            })
//            AppManager.showExpandingMenu(from: popup.mainView, style: .postPopup, selectedIndex: { index in
//                //TO DO
//                AppManager.showAfterEffect(from: self.popup.contentView, style: .postPopup)
//            })
        }
        
    }
}

extension ContestAlbumViewController: DocumentManagerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        _ = UpdatePostContentRouter(viewModel: nil, audioUrl: url.absoluteString).navigate(from: self.navigationController, transitionType: .push, animated: true)
    }
}

extension ContestAlbumViewController {
    private func giveFlowers(_ flower: Int, _ location: SEDraggableLocation!) {
//        if let indexPath = location.index, let item = self.viewModel.datasource.value?[indexPath.row] {
//            self.viewModel.giveFlowerOnRace(flower: flower, uid: item.uid, contest: self.viewModel.contest?.key, ckey: self.viewModel.ckey.value, callback: { (success) in
//                if success {
//                    self.viewModel.getListRanking()
////                    AppManager.showAfterEffect(from: location, style: .cell)
//
//                    let user = UserSessionManager.user()
//                    user?.flowers -= flower
//                    AppManager.shared.updateFlowerNumber(flower: user?.flowers ?? 0)
//                }
//            }, failure: { (error) in
//                self.handle(error)
//            })
//        }
    }
}
