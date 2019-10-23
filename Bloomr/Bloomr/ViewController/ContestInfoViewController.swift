//
//  ContestInfoViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import WebKit
class ContestInfoViewController: BaseViewController {
    let webView: WKWebView = {
        let webkit = WKWebView(frame: .zero)
        return webkit
    }()
    
    let shadowView: ShadowableView = {
        let shadow = ShadowableView(frame: .zero)
        return shadow
    }()
    
    let bottomView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    let joinButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle(TextManager.joinContestText.uppercased().localized(), for: .normal)
        button.titleLabel?.font = UIFont.fromType(.primary(.medium, .h3))
        button.backgroundColor = .aqua
        return button
    }()
    
    let viewModel = ContestInfoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = TextManager.contestRuleText.localized()
        
        let request = URLRequest(url: URL(string:"https://www.apple.com")!)
        webView.load(request)
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = .white
        setupBottomView()
        setupWebview()
        setupBottomView()
        setupShadow()
        setupJoinButton()
        
        handleObservers()
    }
    
    private func setupWebview() {
        self.view.addSubview(webView)
        self.webView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            }
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(self.bottomView.snp.top)
        }
    }
    
    private func setupBottomView() {
        self.view.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints { (maker) in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.height.equalTo(65)
        }
    }
    
    private func setupShadow() {
        self.bottomView.addSubview(shadowView)
        self.shadowView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupJoinButton() {
        self.bottomView.addSubview(self.joinButton)
        self.joinButton.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin_10)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin_10)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func handleObservers() {
        self.viewModel.joinContestSuccess.subscribe(onNext: { (joined) in
            
        }).disposed(by: self.disposeBag)
        
        self.joinButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.viewModel.joinContest(callback: { [weak self] (error) in
                guard let self = self else { return }
                if let error = error {
                    self.handle(error)
                }
            })
        }).disposed(by: self.disposeBag)
    }
    
}
