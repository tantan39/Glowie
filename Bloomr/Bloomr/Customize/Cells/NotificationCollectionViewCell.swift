//
//  NotificationCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/14/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class NotificationCollectionViewCell: BaseCollectionViewCell {
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = Dimension.shared.normalHorizontalMargin
        return stackView
    }()
    
    lazy var avatar: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "avatars")
        return imageView
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        let displayName = NSAttributedString(string: "ABC ", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.bold, .h3)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        let content = NSAttributedString(string: "đã tặng bạn 100 hoa vào cuộc thi Hãy Trao Cho Anh. Hãy nói Thank You!\n", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.medium, .h3)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        let time = NSAttributedString(string: "12:36. Thứ tư ", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h4_10)),
            NSAttributedString.Key.foregroundColor: UIColor.veryLightPink])
        
        let attributeString = NSMutableAttributedString(attributedString: displayName)
        attributeString.append(content)
        attributeString.append(time)
        label.attributedText = attributeString
        
        return label
    }()
    
    lazy var thumbnail: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .french_blue
        return imageView
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupStackView()
        setupAvatar()
        setupContentLabel()
        setupThumbnail()
    }
    
    private func setupStackView() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupAvatar() {
        self.stackView.addArrangedSubview(self.avatar)
        self.avatar.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(Dimension.shared.avatarWidth_45)
        }
        
        self.avatar.layer.cornerRadius = Dimension.shared.avatarWidth_45/2
    }
    
    private func setupContentLabel() {
        self.stackView.addArrangedSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
        }
    }
    
    private func setupThumbnail() {
        self.stackView.addArrangedSubview(self.thumbnail)
        self.thumbnail.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(50)
            maker.bottom.equalToSuperview()
        }
    }
    
    func setValue(message: String?) {
        self.contentLabel.text = message
    }
}
