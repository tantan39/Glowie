//
//  FollowersCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/6/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class FollowersCollectionViewCell: BaseCollectionViewCell {
    let thumbnail: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "avatars")
        return imageView
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        let name = NSAttributedString(string: "Rose\n", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h4_10)),
            NSAttributedString.Key.foregroundColor: UIColor.black70])
        let flower = NSAttributedString(string: "12345", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h4_10)),
            NSAttributedString.Key.foregroundColor: UIColor.black70])
        
        let attributeString = NSMutableAttributedString(attributedString: name)
        attributeString.append(flower)
        label.attributedText = attributeString
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupThumbnail()
        setupInfoLabel()
    }
    
    private func setupThumbnail() {
        self.addSubview(self.thumbnail)
        self.thumbnail.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(Dimension.shared.avatarWidth_45)
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
        }
        
        self.thumbnail.layer.cornerRadius = Dimension.shared.avatarWidth_45/2
        self.thumbnail.clipsToBounds = true
    }
    
    private func setupInfoLabel() {
        self.addSubview(self.infoLabel)
        self.infoLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.thumbnail.snp.bottom)
            maker.centerX.equalToSuperview()
        }
    }
}
