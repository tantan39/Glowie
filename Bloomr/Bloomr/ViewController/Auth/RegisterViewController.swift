//
//  RegisterViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/23/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class RegisterViewController: BaseViewController {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = TextManager.yourPhoneNumberText.localized().uppercased()
        label.font = .fromType(.primary(.medium, .h3))
        label.textColor = .charcoal_grey
        return label
    }()
    
    lazy var phoneTextfield: BaseTextField = {
        let textfield = BaseTextField(frame: .zero)
        textfield.attributedPlaceholder = NSAttributedString(string: TextManager.inputPhoneNumberText.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.veryLightPink])
        textfield.keyboardType = UIKeyboardType.phonePad
        return textfield
    }()
    
    lazy var termAndConditionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let firstString = NSAttributedString(string: "\(TextManager.termpConditionPrefixText.localized())\n", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h4)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        
        let secondString = NSAttributedString(string: TextManager.terms_privacyText.localized(), attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h4)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor: UIColor.charcoal_grey])
        
        let attributeString = NSMutableAttributedString(attributedString: firstString)
        attributeString.append(secondString)
        label.attributedText = attributeString
        let gesture = UITapGestureRecognizer(target: self, action: #selector(labelDidTapped(gesture:)))
        label.addGestureRecognizer(gesture)
        return label
    }()
    
    lazy var submitButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle(TextManager.registerText.localized().uppercased(), for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h3))
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .aqua

        return button
    }()
    
    var viewModel: RegisterViewModel?
    
    convenience init(viewModel: RegisterViewModel?) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        self.view.backgroundColor = .white
        
        setupTitleLabel()
        setupPhoneNumberTextfield()
        setupTermConditionLabel()
        setupSubmitButton()
        
        handleObservers()
    }
    
    private func setupTitleLabel() {
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
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
            maker.top.equalTo(self.titleLabel.snp_bottom).offset(Dimension.shared.mediumVerticalMargin_10)
            maker.height.equalTo(Dimension.shared.textFieldHeight)
            maker.leading.equalTo(self.titleLabel)
            maker.trailing.equalTo(-Dimension.shared.largeHorizontalMargin_48)
        }
    }
    
    private func setupTermConditionLabel() {
        self.view.addSubview(self.termAndConditionLabel)
        self.termAndConditionLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.phoneTextfield.snp_bottom).offset(Dimension.shared.largeVerticalMargin_48)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setupSubmitButton() {
        self.view.addSubview(self.submitButton)
        self.submitButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.termAndConditionLabel.snp_bottom).offset(Dimension.shared.normalVerticalMargin_20)
            maker.leading.trailing.equalTo(self.phoneTextfield)
            maker.height.equalTo(Dimension.shared.buttonHeight)
        }
    }
    
    func handleObservers() {
        self.phoneTextfield.rx.text.subscribe(onNext: { (text) in
            guard let text = text else { return }
            self.submitButton.isEnabled = !text.isEmpty
            self.viewModel?.phoneNumber.accept(text)
        }).disposed(by: self.disposeBag)
        
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
    
    @objc func labelDidTapped(gesture: UITapGestureRecognizer) {
        
        let text = (self.termAndConditionLabel.text)!
        let termsRange = (text as NSString).range(of: TextManager.terms_privacyText.localized())
        
        if gesture.didTapAttributedTextInLabel(label: self.termAndConditionLabel, inRange: termsRange) {
            print("Tapped terms")
            
        } else {
            print("Tapped none")
        }
    }
    
}
