//
//  InputNickNameView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/27/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class InputNickNameView: BaseView {
    
    let textfield: UITextField = {
        let textfield = UITextField(frame: .zero)
        textfield.font = .fromType(.primary(.medium, .h3))
        textfield.textColor = .charcoal_grey
        textfield.placeholder = "Nhập nickname của bạn".localized()
        return textfield
    }()
    
    let lineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .light_grey
        return view
    }()
    
    let warningIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-warning-triangle")
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.fromType(.primary(.regular, .h4_10))
        label.textColor = .brown_grey
        label.text = "Nickname sử dụng trong cuộc thi này.".localized()
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
//        self.backgroundColor = .deepOrange
        setupTextfield()
        setupLineView()
        setupWarningIcon()
        setupDescriptionLabel()
    }
    
    private func setupTextfield() {
        self.addSubview(self.textfield)
        self.textfield.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(22)
            maker.trailing.equalToSuperview().offset(-10)
            maker.top.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func setupLineView() {
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalTo(self.textfield)
            maker.top.equalTo(self.textfield.snp.bottom)
            maker.height.equalTo(1)
        }
    }
    
    private func setupWarningIcon() {
        self.addSubview(warningIcon)
        self.warningIcon.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(10)
            maker.leading.equalTo(self.lineView)
            maker.top.equalTo(self.lineView.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupDescriptionLabel() {
        self.addSubview(descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.warningIcon.snp.trailing).offset(Dimension.shared.smallHorizontalMargin)
            maker.centerY.equalTo(self.warningIcon)
        }
    }
}
