//
//  ChangePasswordViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/28/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ChangePasswordViewController: BaseViewController {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = TextManager.changePasswordText.localized()
        label.font = .fromType(.primary(.bold, .h1))
        label.textColor = .charcoal_grey
        return label
    }()
    
    lazy var passwordTextfield: BaseTextField = {
        let textfield = BaseTextField(frame: .zero)
        textfield.attributedPlaceholder = NSAttributedString(string: TextManager.newPasswordText.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.veryLightPink])
        textfield.isSecureTextEntry = true
        return textfield
    }()

    lazy var confirmTextfield: BaseTextField = {
        let textfield = BaseTextField(frame: .zero)
        textfield.attributedPlaceholder = NSAttributedString(string: TextManager.confirmPasswordText.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.veryLightPink])
        textfield.isSecureTextEntry = true
        return textfield
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.showNavigationBarRightViewStyle(.done)
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
    
        setupTitleLabel()
        setupPasswordTextfield()
        setupConfirmTextfield()
    }
    
    private func setupTitleLabel() {
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(Dimension.shared.largeVerticalMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8 + Dimension.shared.largeVerticalMargin)
            }

            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupPasswordTextfield() {
        self.view.addSubview(self.passwordTextfield)
        self.passwordTextfield.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.height.equalTo(Dimension.shared.textFieldHeight)
        }
    }
    
    private func setupConfirmTextfield() {
        self.view.addSubview(self.confirmTextfield)
        self.confirmTextfield.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.passwordTextfield.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
            maker.leading.trailing.height.equalTo(self.passwordTextfield)
        }
    }
}
