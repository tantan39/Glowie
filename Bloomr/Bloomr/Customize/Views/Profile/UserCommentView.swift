//
//  UserCommentView.swift
//  Bloomr
//
//  Created by Tan Tan on 9/4/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class UserCommentView: BaseView {

    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "avatars")
        return imageView
    }()
    
    lazy var commentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .light_grey
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .charcoal_grey
        label.font = .fromType(.primary(.medium, .h3))
        label.text = "T.N.T.Truc"
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .charcoal_grey
        label.font = .fromType(.primary(.regular, .h3))
        label.numberOfLines = 0
        label.text = "Tặng 10000 hoa nha. Bạn @KhảNgân xinh quá!!"
        
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupAvatarImageView()
        setupCommentView()
        setupDisplayNameLabel()
        setupCommentLabel()
    }
    
    private func setupAvatarImageView() {
        self.addSubview(avatarImageView)
        self.avatarImageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview()
            maker.width.height.equalTo(Dimension.shared.avatarWidth_38)
        }
        self.avatarImageView.layer.cornerRadius = Dimension.shared.avatarWidth_38/2
    }
    
    private func setupCommentView() {
        self.addSubview(self.commentView)
        self.commentView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalTo(self.avatarImageView.snp.trailing).offset(Dimension.shared.smallHorizontalMargin)
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    private func setupDisplayNameLabel() {
        self.commentView.addSubview(self.displayNameLabel)
        self.displayNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            
        }
    }
    
    private func setupCommentLabel() {
        self.commentView.addSubview(self.commentLabel)
        self.commentLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.displayNameLabel.snp.bottom)
            maker.leading.equalTo(self.displayNameLabel)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.bottom.equalToSuperview().inset(Dimension.shared.mediumVerticalMargin)
        }
    }

}
