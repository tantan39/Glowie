//
//  AchievementContestCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/14/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class AchievementContestCell: BaseCollectionViewCell {
    lazy var contestInfoView: AchievementContestInfoView = {
        let view = AchievementContestInfoView(frame: .zero)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let numberOfRows: Int = 3
    let padding: CGFloat = 3
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .white
        
        setupContestInfoView()
        setupCollectionView()
    }
    
    private func setupContestInfoView() {
        self.addSubview(self.contestInfoView)
        self.contestInfoView.snp.makeConstraints { (maker) in
            maker.leading.top.trailing.equalToSuperview()
//            maker.height.equalTo(80)
        }
    }
    
    private func setupCollectionView() {
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.contestInfoView.snp.bottom).offset(Dimension.shared.mediumVerticalMargin_10)
            maker.bottom.equalToSuperview()
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = . horizontal
            layout.minimumLineSpacing = padding
        }
    }
}

extension AchievementContestCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthItem = (self.width-(self.padding * 2))/CGFloat(self.numberOfRows)
        return CGSize(width: widthItem, height: widthItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier(), for: indexPath) as? ThumbnailCollectionViewCell
        return cell ?? UICollectionViewCell()
    }
}
