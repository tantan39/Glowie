//
//  ThankYouCustomView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/21/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ThankYouCustomView: BaseView {
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-thankyou-background")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = TextManager.thankYou.localized()
        label.font = .fromType(.primary(.medium, .h2))
        label.textColor = .white
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupBackground()
        setupTitleLabel()
    }
    
    private func setupBackground() {
        self.addSubview(backgroundImageView)
        self.backgroundImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupTitleLabel() {
        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
        }
    }
}
