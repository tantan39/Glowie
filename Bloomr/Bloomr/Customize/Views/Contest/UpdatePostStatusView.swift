//
//  UpdatePostStatusView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/28/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Photos

enum ThumbnailStyle {
    case normal
    case avatar
}

enum PostContentType {
    case photo
    case audio
    case video
}

class UpdatePostStatusView: BaseView {
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.fromType(.primary(.medium, .h4_10))
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-delete-post"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = .fromType(.primary(.regular, .h2))
        textView.textColor = .veryLightPink
        textView.placeholder = TextManager.whatOnYourMind.localized()
        textView.placeholderColor = .veryLightPink
        textView.autocorrectionType = .no
        return textView
    }()
    
    let coverButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .clear
        button.isHidden = true
        return button
    }()
    
    lazy var maxLengthLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .soft_blue
        lable.text = "0/\(Constant.statusMaxLength)"
        lable.font = .fromType(.primary(.medium, .h4))
        return lable
    }()
    
    lazy var bottomLineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .light_grey
        return view
    }()
    
    lazy var audioPlayer: AudioThumbnailPlayer = {
        let view = AudioThumbnailPlayer(frame: .zero)
        view.isHidden = true
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    var thumbnailStyle: ThumbnailStyle = .normal {
        didSet {
            if thumbnailStyle == .avatar {
                self.thumbnailImageView.layer.cornerRadius = self.thumbnailImageView.height/2
                self.thumbnailImageView.clipsToBounds = true
            }
        }
    }
    
    var postType: PostContentType?
        
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .white
        setupContainerView()
        setupThumbnailImageView()
        setupAudioThumbnail()
        setupDurationLabel()
        setupDeleteButton()
        setupTextView()
        setupCoverButton()
        setupMaxLengthLabel()
        setupBottomLineView()
    }
    
    private func setupContainerView() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupThumbnailImageView() {
        self.containerView.addSubview(self.thumbnailImageView)
        self.thumbnailImageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
            maker.width.equalTo(self.thumbnailImageView.snp.height)
        }
        
    }
    
    private func setupAudioThumbnail() {
        self.thumbnailImageView.addSubview(self.audioPlayer)
        self.audioPlayer.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupDurationLabel() {
        self.thumbnailImageView.addSubview(self.durationLabel)
        self.durationLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupDeleteButton() {
        self.containerView.addSubview(self.deleteButton)
        self.deleteButton.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(20)
            maker.trailing.equalTo(self.thumbnailImageView).offset(-Dimension.shared.smallHorizontalMargin)
            maker.top.equalTo(self.thumbnailImageView).offset(Dimension.shared.smallHorizontalMargin)
        }
        self.deleteButton.layer.cornerRadius = 10
    }
    
    private func setupTextView() {
        self.containerView.addSubview(self.textView)
        self.textView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(Dimension.shared.normalHorizontalMargin)
            maker.top.bottom.equalTo(self.thumbnailImageView)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupCoverButton() {
        self.containerView.addSubview(coverButton)
        self.coverButton.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.bottom.equalTo(self.textView)
        }
    }
    
    private func setupMaxLengthLabel() {
        self.containerView.addSubview(maxLengthLabel)
        self.maxLengthLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupBottomLineView() {
        self.containerView.addSubview(self.bottomLineView)
        self.bottomLineView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
            maker.bottom.equalToSuperview()
        }
    }
}

extension UpdatePostStatusView {
    func setThumbnail(_ asset: PHAsset) {
        self.thumbnailImageView.image = asset.getAssetThumbnail(size: CGSize(width: Dimension.shared.widthScreen/3, height: Dimension.shared.heightScreen/3))
        if asset.mediaType == .video {
            self.durationLabel.isHidden = false
            self.durationLabel.text = asset.duration.durationString()
        } else {
            self.durationLabel.isHidden = true
        }
    }
    
    func configPhoto(image: UIImage?, type: PostContentType) {
        self.thumbnailImageView.image = image
        self.audioPlayer.isHidden = true
        self.durationLabel.isHidden = true

    }
    
    func configAudio(title: String?, duration: String?) {
        self.audioPlayer.isHidden = false
        self.durationLabel.isHidden = true
        self.audioPlayer.setValue(title: title, duration: duration)
    }
    
    func configVideo(image: UIImage?, duration: String?) {
        self.audioPlayer.isHidden = true
        self.thumbnailImageView.image = image
        self.durationLabel.isHidden = false
        self.durationLabel.text = duration
    }
}
