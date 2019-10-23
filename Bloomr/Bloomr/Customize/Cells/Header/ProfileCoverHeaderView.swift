//
//  ProfileCoverHeaderView.swift
//  Bloomr
//
//  Created by Tan Tan on 9/8/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ProfileCoverHeaderViewDelegate: class {
    func uploadCoverButton_didPressed()
    func notificationButton_didPressed()
    func settingButton_didPressed()
}

extension ProfileCoverHeaderViewDelegate {
    func uploadCoverButton_didPressed() { }
    func notificationButton_didPressed() { }
}

class ProfileCoverHeaderView: UICollectionReusableView {
    
    lazy var settingButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-profile-setting"), for: .normal)
        return button
    }()
    
    lazy var inviteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-profile-invite"), for: .normal)
        return button
    }()
    
    lazy var notificationButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-notification-bell"), for: .normal)
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-profile-edit-cover"), for: .normal)
        return button
    }()
    
    lazy var iCarouseView: iCarousel = {
        let view = iCarousel(frame: .zero)
        view.type = iCarouselType.linear
        view.isPagingEnabled = true
        view.autoscroll = 1
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.numberOfPages = self.numberOfBanners
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .deepOrange
        pageControl.currentPage = 0
        return pageControl
    }()
    
    let numberOfBanners: Int = 5
    weak var delegate: ProfileCoverHeaderViewDelegate?
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .veryLightPink
        setupICarouselView()
        setupPageControl()
        setupSettingButton()
        setupInviteButton()
        setupNotificationButton()
        setupEditCoverButton()
        
        handleObservers()
    }
    
    private func setupSettingButton() {
        self.addSubview(self.settingButton)
        self.settingButton.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            maker.width.height.equalTo(Dimension.shared.smallButtonHeight)
        }
    }
    
    private func setupInviteButton() {
        self.addSubview(self.inviteButton)
        self.inviteButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.settingButton)
            maker.leading.equalTo(self.settingButton.snp.trailing).offset(Dimension.shared.normalHorizontalMargin)
            maker.width.height.equalTo(Dimension.shared.smallButtonHeight)
        }
    }
    
    private func setupNotificationButton() {
        self.addSubview(self.notificationButton)
        self.notificationButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.settingButton)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.width.height.equalTo(Dimension.shared.smallButtonHeight)
        }
    }
    
    private func setupEditCoverButton() {
        self.addSubview(self.editButton)
        self.editButton.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupICarouselView() {
        self.addSubview(self.iCarouseView)
        self.iCarouseView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupPageControl() {
        self.addSubview(self.pageControl)
        self.pageControl.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin_12)
            maker.bottom.equalToSuperview()
        }
    }
    
    private func handleObservers() {
        self.editButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.delegate?.uploadCoverButton_didPressed()
        }).disposed(by: self.disposeBag)
        
        self.notificationButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.delegate?.notificationButton_didPressed()
        }).disposed(by: self.disposeBag)
        
        self.settingButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.delegate?.settingButton_didPressed()
        }).disposed(by: self.disposeBag)
    }
}

extension ProfileCoverHeaderView: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.numberOfBanners
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = CoverProfileCustomView(frame: iCarouseView.bounds)
        return view
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.pageControl.currentPage = carousel.currentItemIndex
    }
}
