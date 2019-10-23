//
//  CoverProfileCustomView.swift
//  Bloomr
//
//  Created by Tan Tan on 9/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class CoverProfileCustomView: BaseView {
    lazy var cover: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "banner")
        return imageView
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupCover()
    }
    
    private func setupCover() {
        self.addSubview(self.cover)
        self.cover.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
