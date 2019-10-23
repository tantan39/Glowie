//
//  ExpandingMenuItem.swift
//  Bloomr
//
//  Created by Tan Tan on 8/19/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ExpandingMenuItem: UIView {
    var size: CGSize?
    var image: UIImage?
    var title: String?

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .white
        label.text = self.title
        label.font = .fromType(.primary(.medium, .h2))
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    convenience init(title: String?, image: UIImage?, size: CGSize?, backgroundColor: UIColor?) {
        self.init()
        
        self.title = title
        self.image = image
        self.size = size
        
        self.frame = CGRect(origin: .zero, size: self.size ?? .zero)
        self.layer.cornerRadius = self.width/2
        self.backgroundColor = backgroundColor
        configItem()
    }
    
    func configItem() {
//        self.backgroundColor = .deepOrange
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        titleLabel.text = self.title
        imageView.image = self.image
    }
}
