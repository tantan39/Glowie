//
//  HomeTabBarView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/14/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class HomeTabBarView: BaseView {
    private let primaryImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-tabbar-home"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let secondaryImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-tabbar-home")
        return imageView
    }()
    
    private let flowerNumberLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = ""
        label.font = .fromType(.primary(.regular, .h5))
        label.textColor = .black
        return label
    }()
    
    var flowerNumber: Int = 0 {
        didSet {
            self.flowerNumberLabel.text = flowerNumber.description
        }
    }

    private lazy var homeLocation: SEDraggableLocation = {
        let location = SEDraggableLocation(frame: CGRect(x: 0, y: 0, width: flowerButtonHeight, height: flowerButtonHeight))
        location.objectWidth = Float(flowerButtonHeight)
        location.objectHeight = Float(flowerButtonHeight)
        return location
    }()
    
    lazy var homeDraggable: SEDraggable = {
        let draggable = SEDraggable(imageView: self.primaryImageView)
        return draggable!
    }()
    
    var flowerButtonHeight: CGFloat = Dimension.homeTabBarButtonWidth
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupHomeLocation()
        setupSecondaryImageView()
        setupFlowerNumberLabel()
    }
    
    private func setupHomeLocation() {
        self.addSubview(homeLocation)
        self.homeDraggable.homeLocation = self.homeLocation
        self.homeLocation.addDraggableObject(homeDraggable, animated: false)
        
        self.homeDraggable.isExclusiveTouch = true
        self.bringSubviewToFront(homeDraggable)
    }
    
    private func setupSecondaryImageView() {
        self.insertSubview(self.secondaryImageView, belowSubview: self.homeLocation)
        self.secondaryImageView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.height.equalTo(self.homeLocation)
        }
    }
    
    private func setupFlowerNumberLabel() {
        self.addSubview(self.flowerNumberLabel)
        self.flowerNumberLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.secondaryImageView.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            maker.centerX.equalToSuperview()
        }
    }
}

// MARK: - Support method
extension HomeTabBarView {
    func updateStatus(active: Bool) {
        self.homeDraggable.isHidden = !active
    }
    func goBackToTabBar() {
        self.homeDraggable.askToSnapBack(to: self.homeLocation, animated: true)
    }
}
