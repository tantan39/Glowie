//
//  EditCoverStatusSlideView.swift
//  Bloomr
//
//  Created by Tan Tan on 9/12/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift
class EditCoverStatusSlideView: BaseView {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EditAvatarStatusCell.self, forCellWithReuseIdentifier: EditAvatarStatusCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .deepOrange
        pageControl.currentPage = 0
        return pageControl
    }()
    
    var viewModel: EditCoverViewModel? {
        didSet {
            self.pageControl.numberOfPages = self.viewModel?.covers.value.count ?? 0
            self.collectionView.reloadData()
            
//            self.collectionView.scrollToItem(at: IndexPath(row: self.viewModel?.covers.value.count ?? 1 - 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    let disposeBag = DisposeBag()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .veryLightPinkTwo
        
        setupCollectionView()
        setupPageControl()
        
        handleObservers()
    }
    
    private func setupCollectionView() {
        self.layoutIfNeeded()
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { ( maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo((Dimension.shared.widthScreen/3) + (Dimension.shared.mediumVerticalMargin * 2))
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
            layout.scrollDirection = .horizontal
        }
    }
    
    private func setupPageControl() {
        self.addSubview(self.pageControl)
        self.pageControl.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.collectionView.snp.bottom)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    private func handleObservers() {

    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension EditCoverStatusSlideView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / self.collectionView.width)
        self.pageControl.currentPage = index
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Top padding + thumnail imageview height + bottom padding
//        let estimateHeight = (self.width/3) + (Dimension.shared.mediumVerticalMargin * 2)
        return CGSize(width: collectionView.width, height: collectionView.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.covers.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditAvatarStatusCell.cellIdentifier(), for: indexPath) as? EditAvatarStatusCell, let thumbnail = self.viewModel?.covers.value[indexPath.row] else { return UICollectionViewCell() }
        cell.updatePostStatusView.thumbnailImageView.backgroundColor = .dustyOrange
        cell.updatePostStatusView.thumbnailImageView.image = thumbnail
//        cell.delegate = self
        return cell
    }
}
