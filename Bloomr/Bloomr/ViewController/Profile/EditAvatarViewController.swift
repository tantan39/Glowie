//
//  EditAvatarViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/11/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import CropViewController
class EditAvatarViewController: BaseViewController, ImagePickerController {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var editCoverCustomView: EditCoverStatusSlideView = {
        let view = EditCoverStatusSlideView(frame: .zero)
        view.isHidden = true
        return view
    }()
    
    lazy var titleView: BaseView = {
        let view = BaseView(frame: .zero)
        view.backgroundColor = .veryLightPinkTwo
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .charcoal_grey
        label.font = .fromType(.primary(.regular, .h3))
        label.text = "Ảnh sẽ được lưu vào Cuộc thi VIỆT NAM"
        label.textAlignment = .center
        return label
    }()
    
    lazy var segmentView: BaseView = {
        let view = BaseView(frame: .zero)
        return view
    }()
    
    var segmentedControl: GLXSegmentedControl!
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.cellIdentifier())
        collectionView.register(OpenCameraCell.self, forCellWithReuseIdentifier: OpenCameraCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    var viewModel: EditAvatarViewModel?
    
    convenience init(viewModel: EditAvatarViewModel?) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = TextManager.profilePictureText.localized()
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.showNavigationBarRightViewStyle(.next)
        self.rightBarButton?.isEnabled = false
        
        setupStackView()
        setupEditCoverCustomView()
        setupTitleView()
        setupTitleLabel()
        setupSegmentView()
        setupSegmentControl()
        setupCollectionView()
        
        handleObservers()
    }
    
    private func setupStackView() {
        self.view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            }
            
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupEditCoverCustomView() {
        self.stackView.addArrangedSubview(self.editCoverCustomView)
        
//        self.editCoverCustomView.isHidden = self.viewModel?.editType.value != .cover
    }
    
    private func setupTitleView() {
        self.stackView.addArrangedSubview(self.titleView)
        self.titleView.snp.makeConstraints { (maker) in
            maker.height.equalTo(60)
        }
    }
    
    private func setupTitleLabel() {
        self.titleView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupSegmentView() {
        self.stackView.addArrangedSubview(self.segmentView)
        self.segmentView.snp.makeConstraints { (maker) in
            maker.height.equalTo(60)
        }
    }
    
    private func setupSegmentControl() {
        // Segment control
        let appearance = GLXSegmentAppearance()
        appearance.segmentOnSelectionColor = .white
        appearance.segmentOffSelectionColor = .light_grey
        appearance.titleOnSelectionFont = .fromType(.primary(.medium, .h1))
        appearance.titleOffSelectionFont = .fromType(.primary(.medium, .h1))
        appearance.titleOnSelectionColor = .charcoal_grey
        appearance.titleOffSelectionColor = .charcoal_grey
        appearance.dividerColor = .clear
        appearance.dividerWidth = 0
        appearance.contentHorizontalMargin = 5
        appearance.contentVerticalMargin = 5
        
        self.segmentedControl = GLXSegmentedControl(frame: .zero, segmentAppearance: appearance)
        self.segmentedControl.backgroundColor = UIColor.clear
        
        self.segmentedControl.addSegment(withTitle: "All photos".localized(), onSelectionImage: nil, offSelectionImage: nil)
        self.segmentedControl.addSegment(withTitle: "Ảnh đã có".localized(), onSelectionImage: nil, offSelectionImage: nil)
        
        self.segmentView.addSubview(self.segmentedControl)
        self.segmentedControl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.segmentedControl.addTarget(self, action: #selector(self.switchAlbum(_:)), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.sendActions(for: .valueChanged)
    }
    
    private func setupCollectionView() {
        self.stackView.addArrangedSubview(self.collectionView)
        
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
        self.rightBarButton?.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self, let image = self.viewModel?.galleryViewModel.selectedAssets?.first?.getImageFromPHAsset() else { return }
            
            self.openCropViewController(image,style: .circular, nil)
            
//                let viewController = EditAvatarStatusRouter(viewModel: self.viewModel).navigate(from: self.navigationController, transitionType: .push, animated: true, completion: nil) as? EditAvatarStatusViewController
//                viewController?.avatarCropedImage = image
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.galleryViewModel.selectedAlbum.subscribe(onNext: { [weak self] (album) in
            guard let self = self, let album  = album else { return }
            self.viewModel?.galleryViewModel.fetchAssets(from: album)
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.galleryViewModel.albums.subscribe(onNext: { [weak self] (albums) in
            guard let self = self, let album = albums else { return }            
            self.viewModel?.galleryViewModel.selectedAlbum.accept(album.first)
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.galleryViewModel.assets.subscribe(onNext: { [weak self] (assets) in
            guard let self = self, let _  = assets else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.selectedAlbumType.subscribe(onNext: { [weak self] (type) in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.galleryViewModel.indexSelecteds.subscribe(onNext: { [weak self] (arrayIndex) in
            guard let self = self else { return }
            if self.viewModel?.editType.value == .avatar {
                self.rightBarButton?.isEnabled = true
            } else {
                self.rightBarButton?.isEnabled = arrayIndex.count == 5
                
            }
            
        }).disposed(by: self.disposeBag)
    }
}
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension EditAvatarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.viewModel?.selectedAlbumType.value == .upload {
            return 0
        }
        return self.viewModel?.galleryViewModel.assets.value?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.viewModel?.selectedAlbumType.value == .upload {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.cellIdentifier(), for: indexPath) as? GalleryCollectionViewCell, let asset = self.viewModel?.galleryViewModel.assets.value?.object(at: indexPath.row) else { return UICollectionViewCell() }
            let numberSelected = self.viewModel?.galleryViewModel.indexSelecteds.value
            if numberSelected?.contains(indexPath.row) ?? false {
                let index = numberSelected?.firstIndex(of: indexPath.row) ?? 0
                cell.selectedWithIndex(value: index)
            } else {
                cell.deSelected()
            }
            
            cell.setThumbnail(asset)
            return cell
        }
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenCameraCell.cellIdentifier(), for: indexPath) as? OpenCameraCell
            return cell ?? UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.cellIdentifier(), for: indexPath) as? GalleryCollectionViewCell, let asset = self.viewModel?.galleryViewModel.assets.value?.object(at: indexPath.row - 1) else { return UICollectionViewCell() }
        
        if cell.isSelected {
            cell.selected()
        } else {
            cell.deSelected()
        }
        
        cell.setThumbnail(asset)
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.viewModel?.editType.value == .avatar {
            if self.viewModel?.selectedAlbumType.value == .device {
                if indexPath.row == 0 {
                    // Open camera
                    self.openCamera(from: self)
                } else {
                    let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
                    var numberSelected = self.viewModel?.galleryViewModel.indexSelecteds.value
                    numberSelected?.removeAll()
                    numberSelected?.append(indexPath.row)

                    self.viewModel?.galleryViewModel.indexSelecteds.accept(numberSelected ?? [])
                    cell?.isSelected = true
                    cell?.selected()
                }
            } else {
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if self.viewModel?.editType.value == .avatar {
            if self.viewModel?.selectedAlbumType.value == .device {
                if indexPath.row != 0 {
                    let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
                    cell?.isSelected = false
                    cell?.deSelected()
                }
            } else {
                
            }
        }
    }
}

extension EditAvatarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let style: CropViewCroppingStyle = .circular
        
        openCropViewController(image, style: style ,picker)

    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            let viewController = EditAvatarStatusRouter(viewModel: self.viewModel).navigate(from: self.navigationController, transitionType: .push, animated: true, completion: nil) as? EditAvatarStatusViewController
            viewController?.cropedImage = image
        }
    }
}

// MARK: - Support Method
extension EditAvatarViewController {
     @IBAction func switchAlbum(_ sender: Any) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.viewModel?.selectedAlbumType.accept(.device)
        } else {
            self.viewModel?.selectedAlbumType.accept(.upload)
        }
    }
    
    private func openCropViewController(_ image: UIImage, style: CropViewCroppingStyle,_ picker: UIImagePickerController?) {
        let cropController = CropViewController(croppingStyle: style, image: image)
        cropController.delegate = self
        guard let picker = picker else {
            self.present(cropController, animated: true, completion: nil)
            return
        }
        
        if picker.sourceType == .camera {
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
            })
        } else {
            picker.pushViewController(cropController, animated: true)
        }
        
    }
}
