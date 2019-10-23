//
//  AudioThumbnailPlayer.swift
//  Bloomr
//
//  Created by Tan Tan on 10/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class AudioThumbnailPlayer: BaseView {
    let mainStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .fromType(.primary(.regular, .h6))
        label.textAlignment = .center
        label.text = "Minho & Gao - Hãy trao cho anh "
        label.backgroundColor = .veryLightPinkTwo
        return label
    }()
    
    let playerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .veryLightPinkTwo
        return view
    }()
    
    let playButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon-play-circle"), for: .normal)
        return button
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .fromType(.primary(.regular, .h6))
        label.textAlignment = .right
        label.text = "1:20"
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupMainStackView()
        setupTitleLabel()
        setupPlayerView()
        setupPlayButton()
        setupDurationLabel()

    }
    
    private func setupMainStackView() {
        self.addSubview(self.mainStackView)
        self.mainStackView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.smallHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.smallHorizontalMargin)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(40)
        }
    }
    
    private func setupTitleLabel() {
        self.mainStackView.addArrangedSubview(self.titleLabel)
    }
    
    private func setupPlayerView() {
        self.mainStackView.addArrangedSubview(self.playerView)
        self.playerView.snp.makeConstraints { (maker) in
            maker.height.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    private func setupPlayButton() {
        self.playerView.addSubview(playButton)
        self.playButton.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(-Dimension.shared.smallVerticalMargin)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(Dimension.shared.smallButtonHeight)
        }
        self.playButton.layer.cornerRadius = Dimension.shared.smallButtonHeight/2
    }
    
    private func setupDurationLabel() {
        self.playerView.addSubview(durationLabel)
        self.durationLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.smallVerticalMargin)
            maker.centerY.equalToSuperview()
        }
    }
    
    func setValue(title: String?, duration: String?) {
        self.titleLabel.text = title
        self.durationLabel.text = duration
    }
}
