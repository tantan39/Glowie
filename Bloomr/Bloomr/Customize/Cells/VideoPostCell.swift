//
//  VideoPostCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import AVFoundation
class VideoPostCell: BaseCollectionViewCell {
    let backgroundImageView: UIView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .black
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
    
    var avplayerLayer: AVPlayerLayer? {
        didSet {
            guard let layer = avplayerLayer else { return }
            layer.frame = self.backgroundImageView.frame
            self.backgroundImageView.layer.addSublayer(layer)
        }
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupBackgroundImageView()
    
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

}
