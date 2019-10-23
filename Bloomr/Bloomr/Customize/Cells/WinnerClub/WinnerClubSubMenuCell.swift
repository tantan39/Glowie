//
//  WinnerClubSubMenuCell.swift
//  Bloomr
//
//  Created by Tan Tan on 10/6/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Foundation

class WinnerClubSubMenuCell: BaseCollectionViewCell {
    private let iconImageView: UIImageView = {
        let imgview = UIImageView(frame: .zero)
        imgview.contentMode = .scaleAspectFit
        return imgview
    }()
    
    var type: WinnerType? {
        didSet {
            switch type {
            case .bronze?:
                iconImageView.image = UIImage(named: "icon-gsb-bronze")
            case .silver?:
                iconImageView.image = UIImage(named: "icon-gsb-silver")
            default:
                iconImageView.image =  UIImage(named: "icon-gsb-gold")
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            switch type {
            case .bronze?:
                iconImageView.image = UIImage(named: "icon-gsb-bronze")
            case .silver?:
                iconImageView.image = UIImage(named: "icon-gsb-silver")
            default:
                iconImageView.image =  UIImage(named: "icon-gsb-gold")
            }
        }
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupIconImageView()
    }
    
    private func setupIconImageView() {
        self.addSubview(iconImageView)
        self.iconImageView.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
            maker.width.height.equalTo(20)
        }
    }
    
    func binding(image: UIImage?) {
        self.iconImageView.image = image
    }
}
