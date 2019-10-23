//
//  VerifyPhoneViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/24/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class VerifyPhoneViewController: BaseViewController {
    lazy var phoneLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = TextManager.inputConfirmationPhoneText.localized().uppercased()
        label.font = .fromType(.primary(.medium, .h3))
        label.textColor = .charcoal_grey
        return label
    }()
    
    lazy var phoneTextfield: BaseTextField = {
        let textfield = BaseTextField(frame: .zero)
        textfield.attributedPlaceholder = NSAttributedString(string: TextManager.inputPhoneNumberText.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.veryLightPink])
        textfield.keyboardType = .phonePad
        return textfield
    }()
    
    lazy var submitButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle(TextManager.doneText.localized().uppercased(), for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h3))
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .aqua
        
        return button
    }()
    
    var viewModel: VerifyPhoneViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = VerifyPhoneViewModel()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        self.view.backgroundColor = .white
        
        setupPhoneLabel()
        setupPhoneNumberTextfield()
        setupSubmitButton()
        
        handleObservers()
    }
    
    private func setupPhoneLabel() {
        self.view.addSubview(self.phoneLabel)
        self.phoneLabel.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(Dimension.shared.largeVerticalMargin_60)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8 + Dimension.shared.largeVerticalMargin_60)
            }
            maker.leading.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_48)
        }
    }
    
    private func setupPhoneNumberTextfield() {
        self.view.addSubview(self.phoneTextfield)
        self.phoneTextfield.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.phoneLabel.snp_bottom).offset(Dimension.shared.mediumVerticalMargin_10)
            maker.height.equalTo(Dimension.shared.textFieldHeight)
            maker.leading.equalTo(self.phoneLabel)
            maker.trailing.equalTo(-Dimension.shared.largeHorizontalMargin_48)
        }
    }

    private func setupSubmitButton() {
        self.view.addSubview(self.submitButton)
        self.submitButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.phoneTextfield.snp_bottom).offset(Dimension.shared.largeVerticalMargin_48)
            maker.leading.trailing.equalTo(self.phoneTextfield)
            maker.height.equalTo(Dimension.shared.buttonHeight)
        }
    }
    
    func handleObservers() {
        _ = self.phoneTextfield.rx.text.map { (text) -> Bool in
            if let text = text, !text.isEmpty {
                self.viewModel?.phoneNumber.accept(text)
                return true
                
            }
            return false
        }
        .bind(to: self.submitButton.rx.isEnabled).disposed(by: self.disposeBag)
        
        self.submitButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.viewModel?.requestOTP(completion: { ( result, error) in
                if let error = error {
                    self.handle(error)
                    return
                }
                
                if let otpResult = result as? OTPResult {
                    _ = OTPRouter(result: otpResult, phone: self.viewModel?.phoneNumber.value).navigate(from: self.navigationController, transitionType: .push, animated: true)
                }
            })
        }).disposed(by: self.disposeBag)
        
    }
}
