//
//  InteractiveUsersPageMenuCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class InteractiveUsersPageMenuCell: BaseCollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.regular, .h3))
        label.textColor = .veryLightPink
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            self.titleLabel.textColor = isSelected ? .charcoal_grey : .veryLightPink
        }
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
