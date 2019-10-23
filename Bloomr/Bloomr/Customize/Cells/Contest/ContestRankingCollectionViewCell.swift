//
//  ContestRankingCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/16/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
class ContestRankingCollectionViewCell: BaseCollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let indexLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .fromType(.primary(.medium, .special_20))
        return label
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var thumbnailButton: UIButton = {
        let button = UIButton(frame: .zero)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .charcoal_grey
        label.font = .fromType(.primary(.medium, .h1))
        return label
    }()
    
    private let flowerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let iconFLowerImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "icon_small_flower")
        return imageView
    }()
    
    private let numberFlowerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .fromType(.primary(.medium, .h3))
        return label
    }()
    
    private let viewAlbumButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_album_contest"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .light_grey
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .white
        setupDraggableLocationView()
        setupContainerView()
        setupIndexLabel()
        setupAvatarImageView()
        setupNameLabel()
        setupFlowerView()
        setupIconFlowerImageView()
        setupNumberFlowerLabel()
        setupViewAlbumButton()
        setupBottomLineView()
        
//        self.containerView.addSubview(self.thumbnailButton)
//        self.thumbnailButton.snp.makeConstraints { (maker) in
//            maker.center.equalTo(self.avatarImageView)
//            maker.width.height.equalTo(self.avatarImageView)
//        }
//
//        self.thumbnailButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
//            logDebug("tap pressed")
//        }).disposed(by: self.disposeBag)
    }
    
    private func setupContainerView() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupIndexLabel() {
        self.containerView.addSubview(self.indexLabel)
        self.indexLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            maker.centerY.equalToSuperview()
        }
    }
    
    private func setupAvatarImageView() {
        self.containerView.addSubview(self.avatarImageView)
        self.avatarImageView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.indexLabel.snp.trailing).offset(Dimension.shared.normalVerticalMargin)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(45)
        }
        self.avatarImageView.layer.cornerRadius = 22.5
    }
    
    private func setupNameLabel() {
        self.containerView.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.avatarImageView.snp.trailing).offset(Dimension.shared.largeVerticalMargin)
            maker.bottom.equalTo(self.containerView.snp.centerY)
        }
    }
    
    private func setupFlowerView() {
        self.containerView.addSubview(self.flowerView)
        self.flowerView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.nameLabel)
            maker.top.equalTo(self.nameLabel.snp.bottom)
            maker.height.equalTo(15)
        }
    }
    
    private func setupIconFlowerImageView() {
        self.flowerView.addSubview(self.iconFLowerImageView)
        self.iconFLowerImageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(10)
        }
    }
    
    private func setupNumberFlowerLabel() {
        self.flowerView.addSubview(self.numberFlowerLabel)
        self.numberFlowerLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.iconFLowerImageView.snp.trailing).offset(Dimension.shared.mediumVerticalMargin)
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
    
    private func setupViewAlbumButton() {
        self.containerView.addSubview(self.viewAlbumButton)
        self.viewAlbumButton.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(20)
        }
    }
    
    private func setupBottomLineView() {
        self.containerView.addSubview(self.bottomLineView)
        self.bottomLineView.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.height.equalTo(1)
            maker.leading.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
        }
    }
    
    override func setupDraggableLocationView() {
        // Force layout containerView before add draggableLocation
        self.containerView.addSubview(self.draggableLocation)
        AppManager.shared.homeTabBarView?.homeDraggable.addAllowedDrop(self.draggableLocation)
    }
    
}

extension ContestRankingCollectionViewCell {
    func binding(rank: Int?, avatar: String?, name: String?, flower: Int) {
        self.indexLabel.text = rank?.description
        self.avatarImageView.backgroundColor = .french_blue
        self.nameLabel.text = name
        self.numberFlowerLabel.text = flower.description
        if let strURL = avatar {
            let url = URL(string: strURL)
            self.avatarImageView.kf.setImage(with: url)
        }
    }
}
