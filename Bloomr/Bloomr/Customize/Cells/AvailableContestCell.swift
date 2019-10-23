//
//  AvailableContestCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class AvailableContestCell: BaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.regular, .h1))
        label.numberOfLines = 0
        label.textColor = .charcoal_grey
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .white
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
}

// MARK: - Support Method
extension AvailableContestCell {
    func binding(_ title: String?) {
        self.titleLabel.text = title
    }
}
