//
//  LoginViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/24/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxSwift
import RxCocoa
import SVProgressHUD
class LoginViewController: BaseViewController {
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
        textfield.keyboardType = .phonePad
        return textfield
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = TextManager.passwordText.localized().uppercased()
        label.font = .fromType(.primary(.medium, .h3))
        label.textColor = .charcoal_grey
        return label
    }()
    
    lazy var passwordTextfield: BaseTextField = {
        let textfield = BaseTextField(frame: .zero)
        textfield.attributedPlaceholder = NSAttributedString(string: TextManager.inputPasswordText.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.veryLightPink])
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    lazy var otpButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(TextManager.inputOTPText.localized().uppercased(), for: .normal)
        button.setTitleColor(.veryLightPink, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h4_10))
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(TextManager.forgotPasswordText.localized().uppercased(), for: .normal)
        button.setTitleColor(.veryLightPink, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h4_10))
        return button
    }()
    
    lazy var submitButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle(TextManager.loginText.localized().uppercased(), for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h3))
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .aqua
        button.isEnabled = false
        return button
    }()
    
    lazy var loginFBButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle(TextManager.loginInFBText.localized(), for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h1))
        button.setTitleColor(.duskyBlue, for: .normal)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "icon-register-fb-normal"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -Dimension.shared.mediumHorizontalMargin_10, bottom: 0, right: 0)
        return button
    }()
    
    lazy var bottomView: BaseView = {
        let view = BaseView(frame: .zero)
        return view
    }()
    
    lazy var noAccountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = TextManager.noAccountText.localized()
        label.textColor = .charcoal_grey
        label.font = .fromType(.primary(.regular, .h3))
        return label
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(TextManager.registerText.localized().uppercased(), for: .normal)
        button.setTitleColor(.charcoal_grey, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.bold, .h3))
        return button
    }()
    
    var viewModel: LoginViewModel?
    
    convenience init(viewModel: LoginViewModel?) {
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
        setupPasswordLabel()
        setupPasswordTextfield()
        setupOTPButton()
        setupForgotPasswordButton()
        setupSubmitButton()
        setupLoginFBButton()
        setupBottomView()
        setupNoAccountLabel()
        setupRegisterButton()
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
    
    private func setupPasswordLabel() {
        self.view.addSubview(self.passwordLabel)
        self.passwordLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.phoneTextfield.snp_bottom).offset(Dimension.shared.largeVerticalMargin)
            maker.leading.equalTo(self.phoneTextfield)
        }
    }
    
    private func setupPasswordTextfield() {
        self.view.addSubview(self.passwordTextfield)
        self.passwordTextfield.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.passwordLabel.snp_bottom).offset(Dimension.shared.mediumVerticalMargin_10)
            maker.height.equalTo(Dimension.shared.textFieldHeight)
            maker.leading.equalTo(self.passwordLabel)
            maker.trailing.equalTo(-Dimension.shared.largeHorizontalMargin_48)
        }
    }
    
    private func setupOTPButton() {
        self.view.addSubview(self.otpButton)
        self.otpButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.passwordTextfield.snp_bottom).offset(Dimension.shared.largeVerticalMargin)
            maker.leading.equalTo(self.passwordTextfield)
        }
    }
    
    private func setupForgotPasswordButton() {
        self.view.addSubview(self.forgotPasswordButton)
        self.forgotPasswordButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.otpButton)
            maker.trailing.equalTo(self.passwordTextfield)
        }
    }
    
    private func setupSubmitButton() {
        self.view.addSubview(self.submitButton)
        self.submitButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.otpButton.snp_bottom).offset(Dimension.shared.normalVerticalMargin)
            maker.leading.trailing.equalTo(self.phoneTextfield)
            maker.height.equalTo(Dimension.shared.buttonHeight)
        }
    }
    
    private func setupLoginFBButton() {
        self.view.addSubview(self.loginFBButton)
        self.loginFBButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.height.width.equalTo(self.submitButton)
            maker.top.equalTo(self.submitButton.snp_bottom).offset(Dimension.shared.normalHorizontalMargin_20)
        }
    }
    
    private func setupBottomView() {
        self.view.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin_32)
        }
    }
    
    private func setupNoAccountLabel() {
        self.bottomView.addSubview(self.noAccountLabel)
        self.noAccountLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
        }
    }
    
    private func setupRegisterButton() {
        self.bottomView.addSubview(self.registerButton)
        self.registerButton.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.noAccountLabel.snp.trailing).offset(5)
            maker.centerY.equalTo(self.noAccountLabel)
            maker.top.bottom.trailing.equalToSuperview()
        }
    }
    
    func handleObservers() {
        let validatePhone = self.phoneTextfield.rx.text.map { (text) -> Bool in
            if let text = text, !text.isEmpty { return true }
            return false
        }
        
        let validatePassword = self.passwordTextfield.rx.text.map{ (text) -> Bool in
            if let text = text, !text.isEmpty { return true }
            return false
        }
        
        _ = Observable.combineLatest(validatePhone, validatePassword) { $0 && $1 }
            .bind(to: self.submitButton.rx.isEnabled).disposed(by: self.disposeBag)
        
        self.submitButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            guard let window = UIApplication.shared.keyWindow else { return }
            self.viewModel?.login(phone: self.phoneTextfield.text, password: self.passwordTextfield.text, completion: { [weak self] (_, error) in
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
        
        self.viewModel?.isLoading.subscribe(onNext: { (loading) in
            if loading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        })
        
        self.otpButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            _ = VerifyPhoneRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
        }).disposed(by: self.disposeBag)
        
        self.forgotPasswordButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            _ = ChangePasswordRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
        }).disposed(by: self.disposeBag)
        
        self.registerButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            _ = RegisterRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
        }).disposed(by: self.disposeBag)
    }
}
