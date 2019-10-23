//
//  SettingItemCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class SettingItemCell: BaseCollectionViewCell {
    lazy var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.charcoal_grey
        label.font = UIFont.fromType(.primary(.medium, .h3))
        return label
    }()
    
    lazy var secondaryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.veryLightPink
        label.font = UIFont.fromType(.primary(.medium, .h3))
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .white
        setupTitle()
        setupSecondaryLabel()
    }
    
    private func setupTitle() {
        self.addSubview(self.title)
        self.title.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupSecondaryLabel() {
        self.addSubview(self.secondaryLabel)
        self.secondaryLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
}
