//
//  CommentStatusCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/23/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxSwift
import RxCocoa

class CommentStatusCollectionViewCell: BaseCollectionViewCell {
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .soft_blue
        return imageView
    }()
    
    lazy var commentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .light_grey
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .charcoal_grey
        label.font = .fromType(.primary(.medium, .h3))
        label.text = "T.N.T.Truc"
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .charcoal_grey
        label.font = .fromType(.primary(.regular, .h3))
        label.numberOfLines = 0
        label.text = "Tặng 10000 hoa nha. Bạn @KhảNgân xinh quá!!"

        return label
    }()
    
    lazy var widthConstraint: NSLayoutConstraint = {
        let width = self.contentView.widthAnchor.constraint(equalToConstant: self.bounds.width)
        width.isActive = true
        return width
    }()
    
//    var commentViewGesture: Behavior
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        setupAvatarImageView()
        setupCommentView()
        setupDisplayNameLabel()
        setupCommentLabel()
        setupDraggableLocationView()
        
    }
    
    private func setupAvatarImageView() {
        self.contentView.addSubview(avatarImageView)
        self.avatarImageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.top.equalToSuperview()
            maker.width.height.equalTo(Dimension.shared.avatarWidth_38)
        }
        self.avatarImageView.layer.cornerRadius = Dimension.shared.avatarWidth_38/2
    }
    
    private func setupCommentView() {
        self.contentView.addSubview(self.commentView)
        self.commentView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalTo(self.avatarImageView.snp.trailing).offset(Dimension.shared.smallHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.bottom.equalToSuperview()
        }
        
        self.commentView.addLongPressGestureRecognizer { (gesture) in
            switch gesture.state {
            case .began:
                self.commentView.backgroundColor = .veryLightPink
                AppManager.shared.showActionSheet(title: "Choose a reason".localized(), itemsTitle: ["Annoy".localized(), "spam content".localized()], cancelTitle: "Cancel".localized(), completion: { [weak self] in
                    self?.commentView.backgroundColor = .light_grey
                    }, selectedIndex: { index in
                        
                })
            default:
                break
            }
        }
    }
    
    private func setupDisplayNameLabel() {
        self.commentView.addSubview(self.displayNameLabel)
        self.displayNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            
        }
    }

    private func setupCommentLabel() {
        self.commentView.addSubview(self.commentLabel)
        self.commentLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.displayNameLabel.snp.bottom)
            maker.leading.equalTo(self.displayNameLabel)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.bottom.equalToSuperview().inset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    override func setupDraggableLocationView() {
        let locations = AppManager.shared.homeTabBarView?.homeDraggable.droppableLocations
        if !(locations?.contains(self.draggableLocation) ?? false) { self.commentView.addSubview(self.draggableLocation)}
        self.draggableLocation.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        AppManager.shared.homeTabBarView?.homeDraggable.addAllowedDrop(self.draggableLocation)
    }
    
}

extension CommentStatusCollectionViewCell {
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        widthConstraint.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
}
