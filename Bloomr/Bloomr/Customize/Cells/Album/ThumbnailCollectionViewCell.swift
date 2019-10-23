//
//  PhotoCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class ThumbnailCollectionViewCell: BaseCollectionViewCell {
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .french_blue
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let playButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-play-circle"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupThumbnailImageView()
        setupPlayButton()
        setupDraggableLocationView()
    }
    
    private func setupThumbnailImageView() {
        self.addSubview(self.thumbnailImageView)
        self.thumbnailImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupPlayButton() {
        self.addSubview(self.playButton)
        self.playButton.snp.makeConstraints { (maker) in
            maker.centerY.centerX.equalToSuperview()
            maker.width.height.equalTo(Dimension.shared.buttonHeight_40)
        }
    }
    
    override func setupDraggableLocationView() {
        self.addSubview(self.draggableLocation)
        AppManager.shared.homeTabBarView?.homeDraggable.addAllowedDrop(self.draggableLocation)
    }
}

extension ThumbnailCollectionViewCell {
    func bindingData(imageUrl: String?) {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            self.thumbnailImageView.kf.setImage(with: url)
        }
    }
}
