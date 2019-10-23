//
//  UserProfileCoverHeaderView.swift
//  Bloomr
//
//  Created by Tan Tan on 9/18/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

protocol UserProfileCoverHeaderViewDelegate: class {
    func uploadCoverButton_didPressed()
    func share_didPressed()
    func backButton_didPressed()
}

extension UserProfileCoverHeaderViewDelegate {
    func uploadCoverButton_didPressed() { }
    func notificationButton_didPressed() { }
}

class UserProfileCoverHeaderView: UICollectionReusableView {
    
    lazy var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-back-white"), for: .normal)
        return button
    }()
    
    lazy var reportButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-setting-white"), for: .normal)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-share-white"), for: .normal)
        return button
    }()
    
    lazy var iCarouseView: iCarousel = {
        let view = iCarousel(frame: .zero)
        view.type = iCarouselType.linear
        view.isPagingEnabled = true
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
    weak var delegate: UserProfileCoverHeaderViewDelegate?
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
        setupBackButton()
        setupShareButton()
        setupReportButton()
        
        handleObservers()
    }
    
    private func setupBackButton() {
        self.addSubview(self.backButton)
        self.backButton.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            maker.width.height.equalTo(Dimension.shared.smallButtonHeight)
        }
    }
    
    private func setupShareButton() {
        self.addSubview(self.shareButton)
        self.shareButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.backButton)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.width.height.equalTo(Dimension.shared.smallButtonHeight)
        }
    }
    
    private func setupReportButton() {
        self.addSubview(self.reportButton)
        self.reportButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.shareButton)
            maker.trailing.equalTo(self.shareButton.snp.leading).offset(-Dimension.shared.normalHorizontalMargin)
            maker.width.height.equalTo(Dimension.shared.smallButtonHeight)
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
        
        self.shareButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.delegate?.share_didPressed()
        }).disposed(by: self.disposeBag)
        
        self.backButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.delegate?.backButton_didPressed()
        }).disposed(by: self.disposeBag)
    }
}

extension UserProfileCoverHeaderView: iCarouselDataSource, iCarouselDelegate {
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
