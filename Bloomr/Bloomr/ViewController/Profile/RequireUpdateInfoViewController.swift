//
//  RequireUpdateInfoViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class RequireUpdateInfoViewController: BaseViewController {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-popup-update-info")
        return imageView
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.text = "Ngọc oi, thêm thông tin để hoàn thiện trang cá nhân nhé!"
        label.font = .fromType(.primary(.regular, .h3))
        label.textAlignment = .center
        label.textColor = .charcoal_grey
        return label
    }()
    
    lazy var addButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle(TextManager.addText.localized().uppercased(), for: .normal)
        button.titleLabel?.font = .fromType(.primary(.bold, .h4_10))
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .deepOrange
        return button
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = .white
        
        setupImageView()
        setupContentLabel()
        setupAddButton()
    }
    
    private func setupImageView() {
        self.view.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_40)
            maker.centerX.equalToSuperview()
            maker.width.height.equalTo(90)
        }
    }
    
    private func setupContentLabel() {
        self.view.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.imageView.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
            maker.leading.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin_32)
        }
    }
    
    private func setupAddButton() {
        self.view.addSubview(self.addButton)
        self.addButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentLabel.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
            maker.centerX.equalToSuperview()
            maker.leading.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_38)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin_38)
            maker.height.equalTo(Dimension.shared.buttonHeight_35)
        }
    }
}
