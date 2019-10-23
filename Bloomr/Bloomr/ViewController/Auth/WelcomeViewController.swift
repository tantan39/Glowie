//
//  RegisterViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/23/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IQKeyboardManager
class WelcomeViewController: BaseViewController {
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "bg-splash-screen")
        return imageView
    }()
    
    lazy var logo: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo-glowie-white")
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.center
        stackView.axis = .vertical
        stackView.spacing = Dimension.shared.mediumVerticalMargin_10
        return stackView
    }()
    
    lazy var newRegisterButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle(TextManager.newRegisterText.localized(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h1))
        button.backgroundColor = .white
        return button
    }()
    
    lazy var facebookRegisterButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle(TextManager.registerInFBText.localized(), for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h1))
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.setupBorder(cornerRadius: 5.0, borderWidth: 2, borderColor: .white)
        button.setImage(UIImage(named: "icon-register-fb"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -Dimension.shared.mediumHorizontalMargin_10, bottom: 0, right: 0)
        return button
    }()
    
    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var historyButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-register-history"), for: .normal)
        return button
    }()
    
    lazy var bottomLoginView: BaseView = {
        let view = BaseView(frame: .zero)
        return view
    }()
    
    lazy var hasAccountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = TextManager.hasAccountText.localized()
        label.textColor = .white
        label.font = .fromType(.primary(.regular, .h3))
        return label
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(TextManager.loginText.localized().uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.bold, .h3))
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupBackground()
        setupLogo()
        setupStackView()
        setupNewRegisterButton()
        setupRegisterInFBButton()
        setupHistoryButton()
        setupBottomStackView()
        setupBottomLoginView()
        setupHasAccountLabel()
        setupLoginButton()
        
        handleObservers()
    }
    
    private func setupBackground() {
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.snp.makeConstraints { (maker) in
//            if #available(iOS 11.0, *) {
//                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
//            } else {
//                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
//            }
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupLogo() {
        self.view.addSubview(self.logo)
        self.logo.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func setupStackView() {
        self.view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().multipliedBy(1.3)
        }
    }
    
    private func setupNewRegisterButton() {
        self.stackView.addArrangedSubview(self.newRegisterButton)
        self.newRegisterButton.snp.makeConstraints { (maker) in
            maker.height.equalTo(Dimension.shared.buttonHeight_55)
            maker.width.equalTo(Dimension.shared.largeButtonWidth)
        }
    }
    
    private func setupRegisterInFBButton() {
        self.stackView.addArrangedSubview(self.facebookRegisterButton)
        self.facebookRegisterButton.snp.makeConstraints { (maker) in
            maker.height.width.equalTo(self.newRegisterButton)
        }
    }
    
    private func setupHistoryButton() {
        self.view.addSubview(self.historyButton)
        self.historyButton.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(25)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin_80)
        }
    }
    
    private func setupBottomStackView() {
        self.view.addSubview(self.bottomStackView)
        self.bottomStackView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.historyButton.snp.bottom).offset(Dimension.shared.normalVerticalMargin_20)
        }
    }
    
    private func setupBottomLoginView() {
        self.bottomStackView.addArrangedSubview(self.bottomLoginView)
    }
    
    private func setupHasAccountLabel() {
        self.bottomLoginView.addSubview(self.hasAccountLabel)
        self.hasAccountLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(self.bottomLoginView.snp.centerX)
        }
    }
    
    private func setupLoginButton() {
        self.bottomLoginView.addSubview(self.loginButton)
        self.loginButton.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.hasAccountLabel.snp.trailing).offset(5)
            maker.centerY.equalTo(self.hasAccountLabel)
            maker.top.bottom.equalToSuperview()
        }
    }
    
    private func handleObservers() {
        self.newRegisterButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            _ = RegisterRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
        }).disposed(by: self.disposeBag)
        
        self.loginButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            _ = LoginRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
        }).disposed(by: self.disposeBag)
    }
}
