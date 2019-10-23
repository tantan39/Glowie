//
//  AchievementLocationContestCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/14/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class AchievementLocationContestCell: BaseCollectionViewCell {
    
    lazy var contestInfoView: AchievementContestInfoView = {
        let view = AchievementContestInfoView(frame: .zero)
        return view
    }()
    
    lazy var bigThumbnail: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .french_blue
        return imageView
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
        setupBigThumbnail()
        setupCollectionView()
    }
    
    private func setupContestInfoView() {
        self.addSubview(self.contestInfoView)
        self.contestInfoView.snp.makeConstraints { (maker) in
            maker.leading.top.trailing.equalToSuperview()
        }
    }
    
    private func setupBigThumbnail() {
        self.addSubview(self.bigThumbnail)
        self.bigThumbnail.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contestInfoView.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(self.width * 9/16)
        }
    }
    
    private func setupCollectionView() {
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.bigThumbnail.snp.bottom).offset(padding)
            maker.bottom.equalToSuperview()
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = . horizontal
            layout.minimumLineSpacing = padding
        }
    }
}

extension AchievementLocationContestCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
