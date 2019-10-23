//
//  JoiningContestCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/6/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

protocol JoiningContestCollectionViewCellDelegate: class {
    func didSelectedPostThumbnail(item: GalleryThumbnail?, at index: IndexPath?, postList: [GalleryThumbnail]?)
}

class JoiningContestCollectionViewCell: BaseCollectionViewCell {
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.regular, .h1))
        label.textColor = .charcoal_grey
//        label.text = "Cuộc thi Shinhan Bank"
        return label
    }()
    
    lazy var flowerIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-flower-small")
        return imageView
    }()
    
    lazy var flowerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.regular, .h3))
        label.textColor = .charcoal_grey
        label.text = "1234567"
        return label
    }()
    
    lazy var viewAlbumButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_album_contest"), for: .normal)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    var dataSource: [GalleryThumbnail]?
    let numberOfColumn: Int = 3
    let padding: CGFloat = 3
    let disposeBag = DisposeBag()
    weak var delegate: JoiningContestCollectionViewCellDelegate?
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .white
        
        setupNameLabel()
        setupFlowerIcon()
        setupFlowerLabel()
        setupViewAlbumButton()
        setupCollectionView()
    }
    
    private func setupNameLabel() {
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupFlowerIcon() {
        self.addSubview(self.flowerIcon)
        self.flowerIcon.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.nameLabel)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            maker.width.height.equalTo(Dimension.shared.flowerIconWidth)
        }
    }
    
    private func setupFlowerLabel() {
        self.addSubview(self.flowerLabel)
        self.flowerLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.flowerIcon)
            maker.leading.equalTo(self.flowerIcon.snp.trailing).offset(Dimension.shared.mediumHorizontalMargin)
        }
    }
    
    private func setupViewAlbumButton() {
        self.addSubview(self.viewAlbumButton)
        self.viewAlbumButton.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
            maker.top.equalTo(self.nameLabel.snp.centerY)
            maker.width.height.equalTo(20)
        }
    }

    private func setupCollectionView() {
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.flowerLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin_10)
            maker.bottom.equalToSuperview()
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = . horizontal
            layout.minimumLineSpacing = padding
        }
    }
}

extension JoiningContestCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthItem = (self.width-(self.padding * 2))/CGFloat(numberOfColumn)
        return CGSize(width: widthItem, height: widthItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.cellIdentifier(), for: indexPath) as? ThumbnailCollectionViewCell, let post = self.dataSource?[indexPath.row] else { return UICollectionViewCell() }
        cell.bindingData(imageUrl: post.photoURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let post = self.dataSource?[indexPath.row] else { return }
        self.delegate?.didSelectedPostThumbnail(item: post, at: indexPath, postList: self.dataSource)
    }
}

extension JoiningContestCollectionViewCell {
    func bindingData(title: String?, flower: Int, posts: [GalleryThumbnail]?) {
        self.nameLabel.text = title
        self.flowerLabel.text = flower.description
        self.dataSource = posts
        self.collectionView.reloadData()
    }
}
