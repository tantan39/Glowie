//
//  GalleryViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import BTNavigationDropdownMenu
import Photos
class GalleryViewController: BaseViewController, ImagePickerController {
    
//    lazy var menuView: BTNavigationDropdownMenu = {
//        let items = self.viewModel.albumsTitle.value ?? []
//        let menuView = BTNavigationDropdownMenu(title: items.first ?? "", items: items)
//        return menuView
//    }()
    
    var menuView: BTNavigationDropdownMenu?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.cellIdentifier())
        collectionView.register(OpenCameraCell.self, forCellWithReuseIdentifier: OpenCameraCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let viewModel = GalleryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
//        self.viewModel.loadPhotosFromDevice()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.menuView?.hide()
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.showNavigationBarRightViewStyle(.next)
        
        setupCollectionView()
        
        handleObservers()
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
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 3.0
            let column = 3
            layout.minimumLineSpacing = padding
            layout.minimumInteritemSpacing = padding

            let widthItem =  (self.view.width - (padding * 2)) / CGFloat(column)
            layout.itemSize = CGSize(width: widthItem, height: widthItem)

        }
    }
    
    private func handleObservers() {
        self.rightBarButton?.rx.tap.subscribe(onNext: { _ in
//            _ = UpdatePostContentRouter(viewModel: self.viewModel).navigate(from: self, transitionType: .changeRootController, animated: true)
            self.viewModel.mediaSource.accept(.deviceAlbum)
            self.navigateToUpdateStatus()
        }).disposed(by: self.disposeBag)
        
        self.menuView?.didSelectItemAtIndexHandler = {[weak self] indexPath in
            guard let self = self else { return }
            logDebug("Did select item at index: \(indexPath)")
        }
        
        self.viewModel.selectedAlbum.subscribe(onNext: { [weak self] (album) in
            guard let self = self, let album  = album else { return }
            self.viewModel.fetchAssets(from: album)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.albums.subscribe(onNext: { [weak self] (albums) in
            guard let self = self, let album = albums else { return }
            self.menuView = BTNavigationDropdownMenu(title: self.viewModel.albumsTitle.first ?? "", items: [])
            self.menuView?.arrowImage = UIImage(named: "icon-triangle-down")
            self.menuView?.arrowTintColor = .charcoal_grey
            self.navigationItem.titleView = self.menuView

            self.viewModel.selectedAlbum.accept(album.first)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.assets.subscribe(onNext: { [weak self] (assets) in
            guard let self = self, let _  = assets else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        self.viewModel.indexSelecteds.subscribe(onNext: { [weak self] (indexs) in
            guard let self = self else { return }
            self.rightBarButton?.isEnabled = indexs.count > 0
        }).disposed(by: self.disposeBag)
    }

}

extension GalleryViewController {
    private func navigateToUpdateStatus() {
        let updatePostContentVC = UpdatePostContentViewController(viewModel: self.viewModel)
        self.navigationController?.viewControllers = [updatePostContentVC]
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.assets.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenCameraCell.cellIdentifier(), for: indexPath) as? OpenCameraCell
            return cell ?? UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.cellIdentifier(), for: indexPath) as? GalleryCollectionViewCell, let asset = self.viewModel.assets.value?.object(at: indexPath.row - 1) else { return UICollectionViewCell() }
        
        let numberSelected = self.viewModel.indexSelecteds.value
        if numberSelected.contains(indexPath.row) {
            let index = numberSelected.firstIndex(of: indexPath.row) ?? 0
            cell.selectedWithIndex(value: index + 1)
        } else {
            cell.deSelected()
        }
        
        cell.setThumbnail(asset)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            switch self.viewModel.contestFormat {
            case .video:
                self.openCamera(from: self, mode: .video)
            default:
                self.openCamera(from: self, mode: .photo)
//                self.openCamera(from: self)
            }
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
            var numberSelected = self.viewModel.indexSelecteds.value
            let index = indexPath.row
            
            if !numberSelected.contains(index) {
                if numberSelected.count < Constant.uploadMediaMaxNumber {
                    numberSelected.append(index)
                    cell?.selectedWithIndex(value: (numberSelected.firstIndex(of: index) ?? 0) + 1)
                }
            } else {
                numberSelected.remove(at: numberSelected.firstIndex(of: index) ?? 0)
                collectionView.reloadData()
            }
            self.viewModel.indexSelecteds.accept(numberSelected)
        }
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let type = info[UIImagePickerController.InfoKey.mediaType] as? String
        switch type {
        case "public.image":
            guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
            self.viewModel.captureImage.accept(image)
        case "public.movie":
            guard let urlVideo = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) else { return }
            self.viewModel.videoURL.accept(urlVideo)
        default:
            break
        }
        
        self.viewModel.mediaSource.accept(.camera)
        picker.dismiss(animated: true, completion: nil)
        self.navigateToUpdateStatus()

    }
}
