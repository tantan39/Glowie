//
//  PopupPostViewContoller.swift
//  Bloomr
//
//  Created by Tan Tan on 8/21/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class PopupPostView: BaseView {
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    var mainView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .soft_blue
        return imageView
    }()
    
    var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 10.0
        view.backgroundColor = .white
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .soft_blue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .charcoal_grey
        label.font = .fromType(.primary(.medium, .h3))
        label.text = "T.N.T.Truc"
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .brown_grey
        label.font = .fromType(.primary(.regular, .h3))
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "Hôm nay trời nắng đẹp, mình thì đẹp hơn nắng đúng hơm cả nhà! Hôm nay trời nắng đẹp,"
        return label
    }()
    
    lazy var commentButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.backgroundColor = .deepOrange
        button.titleLabel?.textColor = .white
        button.setTitle(TextManager.tellSomeThing, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h3))
        return button
    }()
    
    lazy var shadowView: ShadowableView = {
        let shadow = ShadowableView(frame: .zero)
        shadow.isBackgroundViewHidden = true
        return shadow
    }()
    
    var closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_popup_cancel"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupBlurView()
        setupMainView()
        setupPhotoImageView()
        setupContentView()
        setupAvatarImageView()
        setupDisplayNameLabel()
        setupContentLabel()
        setupCommentButton()
        setupShadowButtonView()
        setupCloseButton()
        
    }
    
    private func setupBlurView() {
        self.addSubview(blurEffectView)
        self.blurEffectView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.blurEffectView.alpha = 0.9
    }
    
    private func setupMainView() {
        self.addSubview(mainView)
        self.mainView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin_20)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin_20)
            maker.top.equalToSuperview().offset(54)
            maker.height.equalTo(self.height * 2/3)
        }
    }
    
    private func setupPhotoImageView() {
        self.mainView.addSubview(photoImageView)
        self.photoImageView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(self.photoImageView.snp.width).multipliedBy(16/9)
        }
    }
    
    private func setupContentView() {
        self.mainView.addSubview(contentView)
        self.contentView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalTo(self.photoImageView.snp.bottom).offset(-Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupAvatarImageView() {
        self.contentView.addSubview(self.avatarImageView)
        self.avatarImageView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin_12)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin_20)
            maker.width.height.equalTo(34)
        }
        self.avatarImageView.layer.cornerRadius = 17
    }
    
    private func setupDisplayNameLabel() {
        self.contentView.addSubview(self.displayNameLabel)
        self.displayNameLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.avatarImageView.snp.trailing).offset(Dimension.shared.mediumHorizontalMargin)
            maker.top.equalTo(self.avatarImageView.snp.top)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin_20)
        }
    }
    
    private func setupContentLabel() {
        self.contentView.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.avatarImageView.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
            maker.leading.equalTo(self.avatarImageView.snp.leading)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin_20)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin_20)
        }
    }
    private func setupCommentButton() {
        self.addSubview(commentButton)
        self.commentButton.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalTo(self.mainView)
            maker.top.equalTo(self.mainView.snp.bottom).offset(Dimension.shared.mediumVerticalMargin_12)
            maker.height.equalTo(54)
        }
    }
    
    private func setupShadowButtonView() {
        self.addSubview(self.shadowView)
        self.shadowView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(Dimension.shared.buttonHeight_40)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin_20)
        }
        shadowView.layer.cornerRadius = Dimension.shared.buttonHeight_40/2
        shadowView.clipsToBounds = true
    }
    
    private func setupCloseButton() {
        self.shadowView.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { (maker) in
           maker.edges.equalToSuperview()
        }
    }
    
}
