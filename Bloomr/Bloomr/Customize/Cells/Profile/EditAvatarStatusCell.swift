//
//  EditAvatarStatusCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/12/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift
import Photos

class EditAvatarStatusCell: BaseCollectionViewCell {
    lazy var updatePostStatusView: UpdatePostStatusView = {
        let view = UpdatePostStatusView(frame: .zero)
//        view.thumbnailStyle = .avatar
        view.backgroundColor = .white
        view.textView.isEditable = true
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupUpdatePostStatusView()
        handleObservers()
    }
    
    private func setupUpdatePostStatusView() {
        self.addSubview(self.updatePostStatusView)
        self.updatePostStatusView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func handleObservers() {
//        self.updatePostStatusView.coverButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { () in
//            self.delegate?.statusTextView_DidPressed(self)
//        }).disposed(by: self.disposeBag)
    }
}

// MARK: - Support Method
extension EditAvatarStatusCell {
    func setThumbnail(_ asset: PHAsset) {
        self.updatePostStatusView.layoutIfNeeded()
        self.updatePostStatusView.thumbnailImageView.image = asset.getAssetThumbnail(size: CGSize(width: Dimension.shared.widthScreen/3, height: Dimension.shared.heightScreen/3))
        self.updatePostStatusView.thumbnailStyle = .avatar
        self.updatePostStatusView.deleteButton.isHidden = true
    }
    
    func setThumbnail(_ image: UIImage?) {
        guard let image = image else { return }
        self.updatePostStatusView.layoutIfNeeded()
        self.updatePostStatusView.thumbnailImageView.image = image
        self.updatePostStatusView.thumbnailStyle = .avatar
        self.updatePostStatusView.deleteButton.isHidden = true
    }
}
