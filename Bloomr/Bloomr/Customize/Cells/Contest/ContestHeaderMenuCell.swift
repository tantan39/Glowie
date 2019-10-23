//
//  ContestHeaderMenuCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/10/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class ContestHeaderMenuCell: BaseCollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .peach
        label.font = .fromType(.primary(.medium, .h1))
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .orangeRed : .peach
        }
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.centerY.equalToSuperview()
        }
    }
}
