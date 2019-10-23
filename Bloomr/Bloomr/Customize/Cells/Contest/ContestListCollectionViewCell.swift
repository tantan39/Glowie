//
//  ContestCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/10/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ContestListCollectionViewCell: BaseCollectionViewCell {
    
    let categoryView: ContestSubMenuView = {
        let view = ContestSubMenuView(frame: .zero)
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(MainContestListCell.self, forCellWithReuseIdentifier: MainContestListCell.cellIdentifier())
        collectionView.register(AudioContestListCell.self, forCellWithReuseIdentifier: AudioContestListCell.cellIdentifier())
        collectionView.register(VideoContestListCell.self, forCellWithReuseIdentifier: VideoContestListCell.cellIdentifier())
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var homeContestViewModel: HomeContestViewModel? {
        didSet {
            if let viewModel = homeContestViewModel {
                self.categoryView.viewModel = viewModel.contestListCollectionViewModel
                self.collectionView.reloadData()
            }
        }
    }
    
    let disposeBag = DisposeBag()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupHeaderMenuView()
        setupCollectionView()
        
        handleObservers()
    }
    
    private func setupHeaderMenuView() {
        self.addSubview(categoryView)
        self.categoryView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(40)
        }
    }
    
    private func setupCollectionView() {
        self.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.categoryView.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: self.width, height: self.height - 40)
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
        }
        
        self.collectionView.isPagingEnabled = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func handleObservers() {
        self.categoryView.subMenuSelectedIndex.subscribe(onNext: {[weak self] indexPath in
            guard let self = self, let indexPath = indexPath, self.homeContestViewModel?.dataSouce != nil else { return }
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }).disposed(by: self.disposeBag)
    }
}

// MARK: - UIScrollViewDelegate
extension ContestListCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / self.collectionView.width)
        self.categoryView.selectedMenu(at: index)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ContestListCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeContestViewModel?.contestListCollectionViewModel?.dataSource.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contestType = self.homeContestViewModel?.contestListCollectionViewModel?.dataSource[indexPath.row]
        switch contestType {
        case .main?:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainContestListCell.cellIdentifier(), for: indexPath) as? MainContestListCell
            cell?.homeContestViewModel = self.homeContestViewModel
            return cell ?? UICollectionViewCell()
        case .singing?:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioContestListCell.cellIdentifier(), for: indexPath) as? AudioContestListCell
            cell?.homeContestViewModel = self.homeContestViewModel
            return cell ?? UICollectionViewCell()
        case .modeling?:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoContestListCell.cellIdentifier(), for: indexPath) as? VideoContestListCell
            cell?.homeContestViewModel = self.homeContestViewModel
            return cell ?? UICollectionViewCell()
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - Support method
extension ContestListCollectionViewCell {
    
}
