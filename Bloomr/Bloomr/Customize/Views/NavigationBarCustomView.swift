//
//  NavigationBarCustomView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class NavigationBarCustomView: BaseView {
    
    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    let backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-back-white")!.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        return button
    }()
    
    let title: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.medium, .h1))
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Viet Nam Contest"
        return label
    }()
    
    let settingButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-setting-white")!.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .clear
        setupStackView()
        setupBackButton()
        setupTitleLabel()
        setupSettingButton()
    }
    
    private func setupStackView() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupBackButton() {
        self.stackView.addArrangedSubview(self.backButton)
        self.backButton.snp.makeConstraints { (maker) in
            maker.width.equalTo(Dimension.shared.smallButtonWidth)
        }
    }
    
    private func setupTitleLabel() {
        self.stackView.addArrangedSubview(self.title)
    }
    
    private func setupSettingButton() {
        self.stackView.addArrangedSubview(self.settingButton)
        self.settingButton.snp.makeConstraints { (maker) in
            maker.width.equalTo(Dimension.shared.smallButtonWidth)
        }
    }
}
