//
//  GalleryCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Photos
class GalleryCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = .baby_blue
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var highlightView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.deepOrange.withAlphaComponent(0.5)
        view.border(borderWidth: 1.5, cornerRadius: 0, borderColor: .deepOrange)
        view.isHidden = true
        return view
    }()
    
    private lazy var countNumberView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .deepOrange
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private lazy var countNumberLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = .fromType(.primary(.medium, .h4))
        label.textAlignment = .center
        return label
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.fromType(.primary(.medium, .h4_10))
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupThumbnailImageView()
        setupHighlightView()
        setupCountNumberView()
        setupCountNumberLabel()
        setupDurationLabel()
    }
    
    private func setupThumbnailImageView() {
        self.addSubview(self.thumbnailImageView)
        self.thumbnailImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupHighlightView() {
        self.addSubview(self.highlightView)
        self.highlightView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupCountNumberView() {
        self.highlightView.addSubview(self.countNumberView)
        self.countNumberView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.smallVerticalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.smallVerticalMargin)
            maker.width.height.equalTo(20)
        }
        self.countNumberView.layer.cornerRadius = 10
    }
    
    private func setupCountNumberLabel() {
        self.countNumberView.addSubview(self.countNumberLabel)
        self.countNumberLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupDurationLabel() {
        self.addSubview(self.durationLabel)
        self.durationLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
        }
    }
}

extension GalleryCollectionViewCell {
    func setThumbnail(_ thumbnail: UIImage?) {
        guard let image = thumbnail else { return }
        self.thumbnailImageView.image = image
    }
    
    func setThumbnail(_ asset: PHAsset) {
        self.thumbnailImageView.image = asset.getAssetThumbnail(size: CGSize(width: Dimension.shared.widthScreen/3, height: Dimension.shared.heightScreen/3))
        if asset.mediaType == .video {
            self.durationLabel.isHidden = false
            self.durationLabel.text = asset.duration.durationString()
        } else {
            self.durationLabel.isHidden = true
        }
    }
    
    func selected() {
        self.highlightView.isHidden = false
        self.countNumberView.isHidden = true
    }
    
    func selectedWithIndex(value: Int) {
        self.highlightView.isHidden = false
        self.countNumberLabel.text = "\(value)"
    }
    
    func deSelected() {
        self.highlightView.isHidden = true
    }
}
