//
//  StatusHeaderView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/23/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class StatusHeaderView: UICollectionReusableView {
    
    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Dimension.shared.mediumVerticalMargin
        return stackView
    }()
    
    let infoView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .charcoal_grey
        label.font = .fromType(.primary(.medium, .h3))
        label.text = "T.N.T.Truc"
        return label
    }()
    
    lazy var flowerIconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "icon-flower-small")
        return imageView
    }()
    
    let numberFlowerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .charcoal_grey
        label.font = .fromType(.primary(.regular, .h4))
        label.text = "10023"
        return label
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_contest_share"), for: .normal)
        return button
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .brown_grey
        label.font = .fromType(.primary(.regular, .h3))
        label.textAlignment = .left
        label.numberOfLines = 0
//        label.text = "Hôm nay trời nắng đẹp, mình thì đẹp hơn nắng đúng hơm cả nhà! Hôm nay trời nắng đẹp,"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupStackView()
        setupInfoView()
        setupAvatarImageView()
        setupDisplayNameLabel()
        setupFlowerIcon()
        setupNumberFlowerLabel()
        setupShareButton()
        setupContentLabel()
    }
    
    private func setupStackView() {
        self.addSubview(stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.smallVerticalMargin)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupInfoView() {
        self.stackView.addArrangedSubview(self.infoView)
    }
    
    private func setupAvatarImageView() {
        self.infoView.addSubview(avatarImageView)
        self.avatarImageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview()
            maker.width.height.equalTo(Dimension.shared.avatarWidth_38)
            maker.bottom.equalToSuperview()
        }
        self.avatarImageView.layer.cornerRadius = Dimension.shared.avatarWidth_38/2
    }
    
    private func setupDisplayNameLabel() {
        self.infoView.addSubview(self.displayNameLabel)
        self.displayNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            maker.leading.equalTo(self.avatarImageView.snp.trailing).offset(Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupFlowerIcon() {
        self.infoView.addSubview(self.flowerIconImageView)
        self.flowerIconImageView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.displayNameLabel)
            maker.top.equalTo(self.displayNameLabel.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
            maker.width.height.equalTo(8)
        }
    }
    
    private func setupNumberFlowerLabel() {
        self.infoView.addSubview(self.numberFlowerLabel)
        self.numberFlowerLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.flowerIconImageView)
            maker.leading.equalTo(self.flowerIconImageView.snp.trailing).offset(Dimension.shared.smallHorizontalMargin)
        }
    }
    
    private func setupShareButton() {
        self.infoView.addSubview(self.shareButton)
        self.shareButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.displayNameLabel)
            maker.trailing.equalToSuperview()
            maker.width.height.equalTo(Dimension.shared.smallButtonHeight)
        }
    }
    
    private func setupContentLabel() {
        self.stackView.addArrangedSubview(self.contentLabel)
    }
    
}

// MARK: - Support Method
extension StatusHeaderView {
    func bindingData(post: PostDetails?) {
        guard let post = post else { return }
        if let strUrl = post.profile?.avatar, let url = URL(string: strUrl) {
            self.avatarImageView.kf.setImage(with: url)
        }
        self.displayNameLabel.text = post.profile?.name
        self.numberFlowerLabel.text = post.flower.description
        self.contentLabel.text = post.caption
    }
}
