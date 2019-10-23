//
//  ChooseLocationCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/10/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxSwift
import RxCocoa

class ChooseLocationCell: BaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.medium, .h1))
        label.textColor = .veryLightPink
        label.text = TextManager.youAreText.localized().uppercased()
        return label
    }()
    
    lazy var firstCityButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-hn-city"), for: .normal)
        return button
    }()
    
    lazy var firstCityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Ho Chi Minh".localized().uppercased()
        label.font = .fromType(.primary(.medium, .h1))
        label.textColor = .charcoal_grey
        return label
    }()
    
    lazy var secondCityButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-hcm-city"), for: .normal)
        
        return button
    }()
    
    lazy var secondCityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Ha Noi".localized().uppercased()
        label.font = .fromType(.primary(.medium, .h1))
        label.textColor = .charcoal_grey
        return label
    }()
    
    let disposeBag = DisposeBag()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupTitleLabel()
        setupFirstCityButton()
        setupFirstCityLabel()
        setupSecondCityButton()
        setupSecondCityLabel()
        
        handleObservers()
    }
    
    private func setupTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_60)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setupFirstCityButton() {
        self.addSubview(self.firstCityButton)
        self.firstCityButton.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(130)
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview().multipliedBy(0.5)
        }
        
        self.firstCityButton.layer.cornerRadius = 65
        self.firstCityButton.clipsToBounds = true
    }
    
    private func setupSecondCityButton() {
        self.addSubview(self.secondCityButton)
        self.secondCityButton.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(self.firstCityButton)
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview().multipliedBy(1.5)
        }
        
        self.secondCityButton.layer.cornerRadius = 65
        self.secondCityButton.clipsToBounds = true
    }
    
    private func setupFirstCityLabel() {
        self.addSubview(self.firstCityLabel)
        self.firstCityLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.firstCityButton.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            maker.centerX.equalTo(self.firstCityButton)
        }
    }
    
    private func setupSecondCityLabel() {
        self.addSubview(self.secondCityLabel)
        self.secondCityLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.secondCityButton.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            maker.centerX.equalTo(self.secondCityButton)
        }
    }
    
    private func handleObservers() {
        self.firstCityButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.selectedCity(0)
        }).disposed(by: self.disposeBag)
        
        self.secondCityButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.selectedCity(1)
        }).disposed(by: self.disposeBag)
    }
}

// MARK: - Support Method
extension ChooseLocationCell {
    func selectedCity(_ city: Int) {
        if city == 0 {
            self.firstCityLabel.textColor = .deepOrange
            self.secondCityLabel.textColor = .charcoal_grey
            
//            self.femaleButton.setImage(UIImage(named: "icon_contest_main_active"), for: .normal)
//            self.maleButton.setImage(UIImage(named: "icon_tabbar_me_normal"), for: .normal)
        } else if city == 1 {
            self.firstCityLabel.textColor = .charcoal_grey
            self.secondCityLabel.textColor = .deepOrange
            
//            self.femaleButton.setImage(UIImage(named: "icon_contest_main_normal"), for: .normal)
//            self.maleButton.setImage(UIImage(named: "icon_tabbar_me_active"), for: .normal)
        }
    }
}
