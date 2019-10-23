//
//  ClosedContestCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/7/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ClosedContestCollectionViewCell: BaseCollectionViewCell {
    lazy var stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.distribution = .fill
        view.axis = .vertical
        return view
    }()
    
    lazy var thumbnail: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "avatars")
        return imageView
    }()
    
    lazy var centerView: BaseView = {
        let view = BaseView(frame: .zero)
        return view
    }()
    
    lazy var firstLineView: BaseView = {
        let view = BaseView(frame: .zero)
        view.backgroundColor = .veryLightPink
        return view
    }()
    
    lazy var secondLineView: BaseView = {
        let view = BaseView(frame: .zero)
        view.backgroundColor = .veryLightPink
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        let flowerNumber = NSAttributedString(string: "Tháng Năm Rực Rỡ\n", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.light, .h5_9)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        let description = NSAttributedString(string: "Kết thúc: 23/08/2019", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.light, .h5_9)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        
        let attributeString = NSMutableAttributedString(attributedString: flowerNumber)
        attributeString.append(description)
        label.attributedText = attributeString
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupStackView()
        setupThumbnail()
        setupCenterView()
        setupFistLineView()
        setupSecondLineView()
        setupDescriptionLabel()
    }
    
    private func setupStackView() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupThumbnail() {
        self.layoutIfNeeded()
        self.stackView.addArrangedSubview(self.thumbnail)
        self.thumbnail.snp.makeConstraints { (maker) in
            maker.height.equalTo(self.snp.width)
        }
    }
    
    private func setupCenterView() {
        self.stackView.addArrangedSubview(self.centerView)
        self.centerView.snp.makeConstraints { (maker) in
            maker.height.equalTo(4)
        }
    }
    
    private func setupFistLineView() {
        self.centerView.addSubview(self.firstLineView)
        self.firstLineView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(2)
            maker.leading.equalToSuperview().offset(Dimension.shared.smallHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.smallHorizontalMargin)
            maker.height.equalTo(1)
        }
    }
    
    private func setupSecondLineView() {
        self.centerView.addSubview(self.secondLineView)
        self.secondLineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.firstLineView.snp.bottom).offset(1)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin_14)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin_14)
            maker.height.equalTo(1)
        }
    }
    
    private func setupDescriptionLabel() {
        self.stackView.addArrangedSubview(self.descriptionLabel)
    }
}
