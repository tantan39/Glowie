//
//  AudioPostCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class AudioPostCell: BaseCollectionViewCell {
    let backgroundImageView: UIView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "background-audio-post")
        return imageView
    }()
    
    let mainView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .light_grey
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .fromType(.primary(.regular, .h1))
        label.textAlignment = .center
        label.text = "Minho & Gao - Hãy trao cho anh "
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
        label.textColor = .veryLightPink
        label.font = .fromType(.primary(.regular, .h1))
        label.textAlignment = .right
        label.text = "1:20"
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupBackgroundImageView()
        setupMainView()
        setupMainStackView()
        setupTitleLabel()
        setupPlayerView()
        setupPlayButton()
        setupDurationLabel()
//        setupDraggableLocationView()
    }
    
    override func setupDraggableLocationView() {
        self.addSubview(self.draggableLocation)
        AppManager.shared.homeTabBarView?.homeDraggable.addAllowedDrop(self.draggableLocation)
    }
    
    private func setupBackgroundImageView() {
        self.addSubview(backgroundImageView)
        self.backgroundImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupMainView() {
        self.addSubview(mainView)
        mainView.snp.makeConstraints { (maker) in
            maker.width.equalTo(200)
            maker.height.equalTo(70)
            maker.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupMainStackView() {
        self.mainView.addSubview(self.mainStackView)
        self.mainStackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
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
}
