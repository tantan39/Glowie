//
//  ChooseContestInfoViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class CompletionInfoContestViewController: BaseViewController {
    
    lazy var nextButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle(TextManager.nextText.localized().uppercased(), for: .normal)
        button.backgroundColor = .deepOrange
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h1))
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ChooseGenderCell.self, forCellWithReuseIdentifier: ChooseGenderCell.cellIdentifier())
        collectionView.register(ChooseLocationCell.self, forCellWithReuseIdentifier: ChooseLocationCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.numberOfPages = self.nummberOfFields
        pageControl.pageIndicatorTintColor = .veryLightPink
        pageControl.currentPageIndicatorTintColor = .charcoal_grey
        pageControl.currentPage = 0
        return pageControl
    }()
    
    let nummberOfFields: Int = 2
    
    let viewModel = CompletionInfoContestViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = TextManager.informationText.localized().uppercased()
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = .veryLightPinkTwo
        
        setupCollectionView()
        setupPageControl()
        setupNextButton()
    }
    
    private func setupNextButton() {
        self.view.addSubview(nextButton)
        self.nextButton.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.height.equalTo(Dimension.shared.buttonHeight_55)
        }
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            }
            maker.leading.trailing.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(0.5)
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: self.view.width, height: self.view.height * 0.5)
        }
    }
    
    private func setupPageControl() {
        self.view.addSubview(self.pageControl)
        self.pageControl.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.collectionView)
            maker.top.equalTo(self.collectionView.snp.bottom).offset(Dimension.shared.mediumVerticalMargin_10)
            
        }
    }
}

// MARK: - UICollectionViewDataSource, UIScrollViewDelegate
extension CompletionInfoContestViewController: UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / self.collectionView.width)
        self.pageControl.currentPage = index
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nummberOfFields
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseGenderCell.cellIdentifier(), for: indexPath) as? ChooseGenderCell else { return UICollectionViewCell() }
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseLocationCell.cellIdentifier(), for: indexPath) as? ChooseLocationCell else { return UICollectionViewCell() }
            return cell
        }

    }
}
