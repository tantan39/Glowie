//
//  PhotoPostCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import Kingfisher
class PhotoPostCell: BaseCollectionViewCell {
    let postPhotoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupPostPhotoImageView()
//        setupDraggableLocationView()
    }
    
    override func setupDraggableLocationView() {
        self.addSubview(self.draggableLocation)
        AppManager.shared.homeTabBarView?.homeDraggable.addAllowedDrop(self.draggableLocation)
    }
    
    private func setupPostPhotoImageView() {
        self.addSubview(postPhotoImageView)
        self.postPhotoImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
}

extension PhotoPostCell {
    func binding(photoUrl: String?) {
        if let strUrl = photoUrl, let url = URL(string: strUrl) {
            let scale = UIScreen.main.scale
            let p = ResizingImageProcessor(referenceSize: CGSize(width: self.postPhotoImageView.width * scale, height: self.postPhotoImageView.height * scale), mode: .aspectFit)
            self.postPhotoImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1)), .processor(p)], progressBlock: nil) { (image, error, cacheType, imageUR) in
//                self.postPhotoImageView.image = Toucan(image: image!).resize(CGSize(width: 325, height: 325),
//                fitMode: .crop).image
                self.postPhotoImageView.layer.shadowOpacity = 0.5
            }
        }
    }
}
