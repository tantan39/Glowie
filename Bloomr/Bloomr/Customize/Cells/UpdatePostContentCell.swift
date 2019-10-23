//
//  UpdateContentPostCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import UITextView_Placeholder
import RxSwift
import RxCocoa
import Photos

protocol UpdatePostContentCellDelegate: class {
    func statusTextView_DidPressed(_ cell: UpdatePostContentCell?)
}

class UpdatePostContentCell: BaseCollectionViewCell {
    lazy var updatePostStatusView: UpdatePostStatusView = {
        let view = UpdatePostStatusView(frame: .zero)
        view.backgroundColor = .white
        view.textView.isEditable = false
        view.coverButton.isHidden = false
        return view
    }()
    
    let disposeBag = DisposeBag()
    weak var delegate: UpdatePostContentCellDelegate?
    
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
        self.updatePostStatusView.coverButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { () in
            self.delegate?.statusTextView_DidPressed(self)
        }).disposed(by: self.disposeBag)
    }
}

extension UpdatePostContentCell {
    func setThumbnail(_ asset: PHAsset) {
        self.updatePostStatusView.thumbnailImageView.image = asset.getAssetThumbnail(size: CGSize(width: Dimension.shared.widthScreen/3, height: Dimension.shared.heightScreen/3))
        if asset.mediaType == .video {
            self.updatePostStatusView.durationLabel.isHidden = false
            self.updatePostStatusView.durationLabel.text = asset.duration.durationString()
        } else {
            self.updatePostStatusView.durationLabel.isHidden = true
        }
    }
    
    func setThumbnail(_ image: UIImage, caption: String?) {
        self.updatePostStatusView.thumbnailImageView.image = image
        self.updatePostStatusView.textView.text = caption
    }
    
    func setAudioContent(_ image: UIImage, caption: String?, title: String?, duration: String?) {
        self.updatePostStatusView.thumbnailImageView.image = image
        self.updatePostStatusView.textView.text = caption
        self.updatePostStatusView.configAudio(title: title, duration: duration)
    }
    
    func setVideoContent(_ image: UIImage, caption: String?, duration: String?) {
        self.updatePostStatusView.thumbnailImageView.image = image
        self.updatePostStatusView.textView.text = caption
        self.updatePostStatusView.configVideo(image: image, duration: duration)
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let view = super.hitTest(point, with: event)
//        if view == self.textView {
//            self.delegate?.statusTextView_DidPressed(self)
//        }
//        return view
//    }
}
