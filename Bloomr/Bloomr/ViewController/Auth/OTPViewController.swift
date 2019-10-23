//
//  OTPViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/23/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import KWVerificationCodeView
import SVProgressHUD
class OTPViewController: BaseViewController {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = TextManager.inputConfirmationCodeText.localized().uppercased()
        label.font = .fromType(.primary(.medium, .h1))
        label.textColor = .charcoal_grey
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        let description = NSAttributedString(string: "\(TextManager.confirmationCodeSendToPhoneText.localized()) \n\n", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h3)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        let phone = NSAttributedString(string: self.viewModel?.phone.value ?? "", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.medium, .h3)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        
        let attributeString = NSMutableAttributedString(attributedString: description)
        attributeString.append(phone)
        label.attributedText = attributeString
        return label
    }()
    
    lazy var otpView: KWVerificationCodeView = {
        let view = KWVerificationCodeView(frame: CGRect(x: 0, y: 0, width: 250, height: 60))
        view.delegate = self
        view.underlineColor = .veryLightPinkTwo
        view.textColor = .aqua
        view.underlineSelectedColor = .clear
        view.textFieldTintColor = .aqua
        return view
    }()
    
    lazy var submitButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.backgroundColor = .aqua
        button.setTitle(TextManager.doneText.localized().uppercased(), for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h3))
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    var viewModel: OTPViewModel?
    
    convenience init(status: OTPResult?, phone: String?) {
        self.init()
        self.viewModel = OTPViewModel(status, phone)
//        self.phoneNumber = phone
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        self.view.backgroundColor = .white
        
        setupTitle()
        setupDescriptionLabel()
        setupOTPView()
        setupSubmitButton()
        
        handleObservers()
    }
    
    private func setupTitle() {
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(Dimension.shared.largeVerticalMargin_60)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8 + Dimension.shared.largeVerticalMargin_60)
            }
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setupDescriptionLabel() {
        self.view.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.titleLabel.snp_bottom).offset(Dimension.shared.mediumVerticalMargin_10)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setupOTPView() {
        self.view.addSubview(self.otpView)
        self.otpView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.descriptionLabel.snp_bottom).offset(Dimension.shared.largeVerticalMargin_56)
            maker.height.equalTo(60)
            maker.width.equalTo(250)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setupSubmitButton() {
        self.view.addSubview(self.submitButton)
        self.submitButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.otpView.snp_bottom).offset(Dimension.shared.largeVerticalMargin_120)
            maker.width.equalTo(Dimension.shared.largeButtonWidth)
            maker.height.equalTo(Dimension.shared.buttonHeight)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func handleObservers() {
        self.submitButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            guard let window = UIApplication.shared.keyWindow else { return }
            
            self.viewModel?.verifyOTP(self.viewModel?.otpCode.value, completion: { [weak self] (user, error) in
                guard let self = self else { return }
                if let error = error {
                    self.handle(error)
                    return
                }
                
                self.viewModel?.fetchProfile(completionBlock: { (user, error) in
                    if let error = error {
                        self.handle(error)
                        return
                    }
                    
                    if let _ = user as? User {
                        _ = HomeTabBarRouter().navigate(from: window, transitionType: .changeRootController, animated: true)
                    }
                })
            })
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.isLoading.subscribe(onNext: { [weak self] (loading) in
            guard let self = self else { return }
            if loading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: self.disposeBag)
    }
}

// MARK: - KWVerificationCodeViewDelegate
extension OTPViewController: KWVerificationCodeViewDelegate {
    func didChangeVerificationCode() {
        self.submitButton.isEnabled = self.otpView.hasValidCode()
        self.viewModel?.otpCode.accept(self.otpView.getVerificationCode())
    }
}
