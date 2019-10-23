//
//  ChooseGenderCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/10/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

class ChooseGenderCell: BaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.medium, .h1))
        label.textColor = .veryLightPink
        label.text = TextManager.youAreText.localized().uppercased()
        return label
    }()
    
    lazy var femaleButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-female-normal"), for: .normal)
//        button.border(borderWidth: 1, cornerRadius: 0, borderColor: .light_grey)
        return button
    }()
    
    lazy var femaleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = TextManager.femaleText.localized().uppercased()
        label.font = .fromType(.primary(.medium, .h1))
        label.textColor = .charcoal_grey
        return label
    }()
    
    lazy var maleButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-male-normal"), for: .normal)
//        button.border(borderWidth: 1, cornerRadius: 0, borderColor: .light_grey)
        return button
    }()
    
    lazy var maleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = TextManager.maleText.localized().uppercased()
        label.font = .fromType(.primary(.medium, .h1))
        label.textColor = .charcoal_grey
        return label
    }()
    
    let disposeBag = DisposeBag()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupTitleLabel()
        setupFemaleButton()
        setupFemaleLabel()
        setupMaleButton()
        setupMaleLabel()
        
        handleObservers()
    }
    
    private func setupTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_60)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setupFemaleButton() {
        self.addSubview(self.femaleButton)
        self.femaleButton.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(130)
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func setupMaleButton() {
        self.addSubview(self.maleButton)
        self.maleButton.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(self.femaleButton)
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview().multipliedBy(1.5)
        }
    }
    
    private func setupFemaleLabel() {
        self.addSubview(self.femaleLabel)
        self.femaleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.femaleButton.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            maker.centerX.equalTo(self.femaleButton)
        }
    }
    
    private func setupMaleLabel() {
        self.addSubview(self.maleLabel)
        self.maleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.maleButton.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            maker.centerX.equalTo(self.maleButton)
        }
    }
    
    private func handleObservers() {
        self.femaleButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.selectedGender(.female)
        }).disposed(by: self.disposeBag)
        
        self.maleButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.selectedGender(.male)
        }).disposed(by: self.disposeBag)
    }
}
// MARK: - Support Method
extension ChooseGenderCell {
    func selectedGender(_ gender: Gender) {
        if gender == .female {
            self.femaleLabel.textColor = .deepOrange
            self.maleLabel.textColor = .charcoal_grey
            
            self.femaleButton.setImage(UIImage(named: "icon-female-active"), for: .normal)
            self.maleButton.setImage(UIImage(named: "icon-male-normal"), for: .normal)
        } else if gender == .male {
            self.femaleLabel.textColor = .charcoal_grey
            self.maleLabel.textColor = .deepOrange
            
            self.femaleButton.setImage(UIImage(named: "icon-female-normal"), for: .normal)
            self.maleButton.setImage(UIImage(named: "icon-male-active"), for: .normal)
        }
    }
}
