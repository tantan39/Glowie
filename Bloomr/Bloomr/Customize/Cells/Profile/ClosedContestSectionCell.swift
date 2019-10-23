//
//  ClosedContestCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/6/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ClosedContestSectionCell: BaseCollectionViewCell {
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.regular, .h1))
        label.textColor = .charcoal_grey
        label.text = "Cuộc thi đã kết thúc".localized()
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ClosedContestCollectionViewCell.self, forCellWithReuseIdentifier: ClosedContestCollectionViewCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .white
        
        setupNameLabel()
        setupCollectionView()
    }
    
    private func setupNameLabel() {
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
        }
        
    }
    
    private func setupCollectionView() {
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 3
            layout.minimumLineSpacing = 3
        }
    }

}

extension ClosedContestSectionCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.width - 6)/3, height: self.collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClosedContestCollectionViewCell.cellIdentifier(), for: indexPath) as? ClosedContestCollectionViewCell
        cell?.backgroundColor = .veryLightPinkTwo
        return cell ?? UICollectionViewCell()
    }
}
