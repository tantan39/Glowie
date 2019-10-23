//
//  ContestRankingHeaderCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/22/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ContestRankingHeaderCell: BaseCollectionViewCell {
    
    let bannerImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "banner")
        imageView.backgroundColor = .veryLightPinkTwo
        return imageView
    }()
    
    lazy var rankIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-ranking")
        return imageView
    }()
    
    lazy var viewDetailButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(TextManager.viewAlbumContestText.localized(), for: .normal)
        button.setTitleColor(.light_grey, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h4_10))
        return button
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupBannerImageView()
        setupRankIcon()
        setupViewDetailButton()
    }
    
    private func setupBannerImageView() {
        self.addSubview(self.bannerImageView)
        self.bannerImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupRankIcon() {
        self.addSubview(self.rankIcon)
        self.rankIcon.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.width.equalTo(Dimension.shared.buttonHeight_35)
            maker.height.equalTo(Dimension.shared.buttonHeight_40)
        }
    }
    
    private func setupViewDetailButton() {
        self.addSubview(self.viewDetailButton)
        self.viewDetailButton.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin_12)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin_10)
        }
    }
}

extension ContestRankingHeaderCell {
    func setBanner(imageUrl: String?) {
        guard let imageURL = imageUrl, let url = URL(string: imageURL) else { return }
        self.bannerImageView.kf.setImage(with: url)
    }
}
