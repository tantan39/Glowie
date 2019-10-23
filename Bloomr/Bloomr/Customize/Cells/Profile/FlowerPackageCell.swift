//
//  FlowerPackageCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/16/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class FlowerPackageCell: BaseCollectionViewCell {
    
    lazy var containerView: BaseView = {
        let view = BaseView(frame: .zero)
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        return stackView
    }()
    
    lazy var titleStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = -Dimension.shared.normalVerticalMargin
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "2.000 HOA"
        label.font = .fromType(.primary(.medium, .h2))
        label.textColor = .charcoal_grey
        return label
    }()
    
    lazy var bonusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "(+5%): 500 HOA"
        label.font = .fromType(.primary(.medium, .h2))
        label.textColor = .aqua
        label.textAlignment = .center
        return label
    }()
    
    lazy var centerLine: BaseView = {
        let view = BaseView(frame: .zero)
        view.backgroundColor = .veryLightPinkTwo
        return view
    }()
    lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "22.000 VNĐ"
        label.font = .fromType(.primary(.regular, .h2))
        label.textColor = .charcoal_grey
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            self.stackView.backgroundColor = isSelected ? .deepOrange : .white
            self.title.textColor = isSelected ? .white : .charcoal_grey
            self.bonusLabel.textColor = isSelected ? .white : .aqua
            self.priceLabel.textColor = isSelected ? .white : .charcoal_grey
        }
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupContainerView()
        setupStackView()
        setupTitleView()
        setupTitleLabel()
        setupBonusLabel()
        setupCenterLine()
        setupPriceLabel()
    }
    
    private func setupContainerView() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalTo(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalTo(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupStackView() {
        self.containerView.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupTitleView() {
        self.stackView.addArrangedSubview(self.titleStackView)
    }
    
    private func setupTitleLabel() {
        self.titleStackView.addArrangedSubview(self.title)
    }
    
    private func setupBonusLabel() {
        self.titleStackView.addArrangedSubview(self.bonusLabel)
    }
    
    private func setupCenterLine() {
        self.stackView.addSubview(centerLine)
        self.centerLine.snp.makeConstraints { (maker) in
            maker.width.equalTo(1)
            maker.center.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    private func setupPriceLabel() {
        self.stackView.addArrangedSubview(self.priceLabel)
    }
}
