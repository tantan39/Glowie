//
//  ContestRankingHeaderView.swift
//  Bloomr
//
//  Created by Tan Tan on 9/22/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class ContestRankingHeaderView: UICollectionReusableView {
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(ContestRankingHeaderCell.self, forCellWithReuseIdentifier: ContestRankingHeaderCell.cellIdentifier())
        return collectionView
    }()
    
    var viewModel: ContestRankingViewModel? {
        didSet {
            if let viewModel = self.viewModel, let _ = viewModel.banners.value {
                self.collectionView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        self.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: self.width, height: self.height)
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
        }
        self.collectionView.isPagingEnabled = true
        self.collectionView.dataSource = self
    }
}

extension ContestRankingHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.banners.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestRankingHeaderCell.cellIdentifier(), for: indexPath) as? ContestRankingHeaderCell, let banner = self.viewModel?.banners.value?[indexPath.row] else { return UICollectionViewCell() }
        cell.setBanner(imageUrl: banner.photo_url)
        return cell
    }
}
