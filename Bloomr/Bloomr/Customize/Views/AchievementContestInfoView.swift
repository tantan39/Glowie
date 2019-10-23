//
//  AchievementContestInfoView.swift
//  Bloomr
//
//  Created by Tan Tan on 9/14/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class AchievementContestInfoView: BaseView {
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.regular, .h1))
        label.textColor = .charcoal_grey
        label.text = "Cuộc thi Shinhan Bank"
        return label
    }()
    
    lazy var flowerIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-glowie-small")
        return imageView
    }()
    
    lazy var flowerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.regular, .h3))
        label.textColor = .charcoal_grey
        label.text = "1234567"
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "12th 6 2019"
        label.font = .fromType(.primary(.regular, .h3))
        label.textColor = .brown_grey
        return label
    }()
    
    lazy var rankingIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-ranking-orange")
        return imageView
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupNameLabel()
        setupFlowerIcon()
        setupFlowerLabel()
        setupDateLabel()
        setupIconRanking()
    }
    
    private func setupNameLabel() {
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupFlowerIcon() {
        self.addSubview(self.flowerIcon)
        self.flowerIcon.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.nameLabel)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
            maker.width.height.equalTo(Dimension.shared.flowerIconWidth)
        }
    }
    
    private func setupFlowerLabel() {
        self.addSubview(self.flowerLabel)
        self.flowerLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.flowerIcon)
            maker.leading.equalTo(self.flowerIcon.snp.trailing).offset(Dimension.shared.mediumHorizontalMargin)
            maker.bottom.equalToSuperview()
        }
    }
    
    private func setupDateLabel() {
        self.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.centerY.equalTo(self.nameLabel.snp.bottom)
        }
    }
    
    private func setupIconRanking() {
        self.addSubview(self.rankingIcon)
        self.rankingIcon.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(self.dateLabel.snp.leading).offset(-Dimension.shared.normalHorizontalMargin)
            maker.centerY.equalTo(self.dateLabel)
            maker.width.height.equalTo(Dimension.shared.avatarWidth_38)
        }
    }
}
