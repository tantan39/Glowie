//
//  ContestBannerCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/28/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ContestBannerCollectionViewCell: BaseCollectionViewCell {
    
    let bannerImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .veryLightPinkTwo
        imageView.image = UIImage(named: "banner")
        return imageView
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupBannerImageView()
    }
    
    private func setupBannerImageView() {
        self.addSubview(self.bannerImageView)
        self.bannerImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
