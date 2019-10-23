//
//  UserInfoView.swift
//  Bloomr
//
//  Created by Tan Tan on 9/4/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class UserInfoView: BaseView {

    lazy var avatarView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var uploadIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-edit-avatar")
        imageView.backgroundColor = .veryLightPinkTwo
        return imageView
    }()
    
    lazy var uploadButton: UIButton = {
        let button = UIButton(frame: .zero)
        
        return button
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        let displayName = NSAttributedString(string: "Nguyễn Trần Khả Ngân\n", attributes: [
                                                                NSAttributedString.Key.font: UIFont.fromType(.primary(.medium, .h1)),
                                                                NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        let location = NSAttributedString(string: "TP. Hồ Chí Minh", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h3)),
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        let attributeString = NSMutableAttributedString(attributedString: displayName)
        attributeString.append(location)
        label.attributedText = attributeString
        return label
    }()
    
    lazy var gsbIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-gsb-gold")
        return imageView
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupAvatarView()
        setupAvatarImageView()
        setupUploadIcon()
        setupUploadButton()
        setupInfoLabel()
        setupGSBIcon()
    }

    private func setupAvatarView() {
        self.addSubview(self.avatarView)
        self.avatarView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            maker.width.height.equalTo(Dimension.shared.avatarWidth_60)
        }
    }
    
    private func setupAvatarImageView() {
        self.avatarView.addSubview(self.avatarImageView)
        self.avatarImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.layoutIfNeeded()
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.width/2
        self.avatarImageView.clipsToBounds = true
    }
    
    private func setupUploadIcon() {
        self.avatarView.addSubview(self.uploadIcon)
        self.uploadIcon.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(22)
            maker.trailing.bottom.equalToSuperview()
        }
        self.uploadIcon.layer.cornerRadius = 11
        self.uploadIcon.clipsToBounds = true
    }
    
    private func setupUploadButton() {
        self.avatarView.addSubview(self.uploadButton)
        self.uploadButton.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupInfoLabel() {
        self.addSubview(self.infoLabel)
        self.infoLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.avatarView.snp.trailing).offset(Dimension.shared.mediumHorizontalMargin_12)
            maker.centerY.equalTo(self.avatarView)
        }
    }
    
    private func setupGSBIcon() {
        self.addSubview(self.gsbIcon)
        self.gsbIcon.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview()
            maker.centerY.equalTo(self.avatarView)
        }
    }
}

extension UserInfoView {
    func setInfo(name: String?, location: String?, avatarUrl: String?) {
        let displayName = NSAttributedString(string: "\(name ?? "")\n", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.medium, .h1)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        let location = NSAttributedString(string: location ?? "", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h3)),
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        let attributeString = NSMutableAttributedString(attributedString: displayName)
        attributeString.append(location)
        self.infoLabel.attributedText = attributeString
        
        if let avatar = avatarUrl {
            let url = URL(string: avatar)!
            self.avatarImageView.kf.setImage(with: url)
        }
    }
}
