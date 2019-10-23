//
//  AudioBackgroundCell.swift
//  Bloomr
//
//  Created by Tan Tan on 10/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class AudioBackgroundCell: BaseCollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupImageView()
    }
    
    private func setupImageView() {
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
