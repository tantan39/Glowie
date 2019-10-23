//
//  PlayerControlCustomView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxSwift

class PlayerControlsCustomView: BaseView {
    
    let previousButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-player-prev"), for: .normal)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-player-next"), for: .normal)
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-player-play"), for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let indexNumberLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.bold, .h2))
        label.textColor = .white
        return label
    }()
    
    let speakerButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-player-speaker-on"), for: .normal)
        return button
    }()
    
    let toggleIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-toggle-pulley")
        return imageView
    }()

    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupPreviousButton()
        setupNextButton()
        setupPlayButton()
        setupIndexNumberLabel()
        setupSpeakerButton()
        setupToggleIcon()
    }
    
    private func setupPreviousButton() {
        self.addSubview(self.previousButton)
        self.previousButton.snp.makeConstraints { (maker) in
            maker.leading.equalTo(Dimension.shared.mediumHorizontalMargin)
            maker.width.height.equalTo(Dimension.shared.smallButtonHeight)
            maker.centerY.equalToSuperview()
        }
    }
    
    private func setupNextButton() {
        self.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(-Dimension.shared.mediumHorizontalMargin)
            maker.width.height.equalTo(Dimension.shared.smallButtonHeight)
            maker.centerY.equalToSuperview()
        }
    }
    
    private func setupPlayButton() {
        self.addSubview(self.playButton)
        self.playButton.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(Dimension.shared.buttonHeight)
            maker.centerY.centerX.equalToSuperview()
        }
    }
    
    private func setupIndexNumberLabel() {
        self.addSubview(self.indexNumberLabel)
        self.indexNumberLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupSpeakerButton() {
        self.addSubview(self.speakerButton)
        self.speakerButton.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupToggleIcon() {
        self.addSubview(self.toggleIcon)
        self.toggleIcon.snp.makeConstraints { (maker) in
            maker.bottom.centerX.equalToSuperview().offset(-Dimension.shared.smallVerticalMargin)
            maker.width.equalTo(Dimension.shared.buttonHeight_40)
            maker.height.equalTo(20)
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if self.point(inside: point, with: event) {
//            return super.hitTest(point, with: event)
//        }
//        guard isUserInteractionEnabled, !isHidden, alpha > 0 else {
//            return nil
//        }
        
        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            if let hitView = subview.hitTest(convertedPoint, with: event) {
                return hitView
            }
        }
        return nil
    }
}

extension PlayerControlsCustomView {
    func enablePlayerControl(_ enable: Bool) {
        self.playButton.isHidden = !enable
        self.speakerButton.isHidden = !enable
    }
    
    func updateStatus(_ pause: Bool) {
        let image = pause ? UIImage(named: "icon-player-play") : UIImage(named: "icon-player-pause")
        self.playButton.setImage(image, for: .normal)
    }
    
    func updateSpeakerStatus(_ on: Bool) {
        let image = on ? UIImage(named: "icon-player-speaker-on") : UIImage(named: "icon-player-speaker-off")
        self.speakerButton.setImage(image, for: .normal)
    }
    
    func setIndex(index: Int, total: Int) {
        self.indexNumberLabel.text = "\(index)/\(total)"
        self.nextButton.isHidden = index == total
        self.previousButton.isHidden = index == 1
    }
}
