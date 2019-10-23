//
//  EnableNotificationPopup.swift
//  Bloomr
//
//  Created by Tan Tan on 9/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class RemindNotificationPopup: BaseView {
    lazy var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        let flowerNumber = NSAttributedString(string: "THÔNG BÁO ĐÃ BỊ TẮT.".localized(), attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h3)),
            NSAttributedString.Key.foregroundColor: UIColor.white])
        let description = NSAttributedString(string: " BẬT LẠI THÔNG BÁO".localized(), attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.bold, .h3)),
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let attributeString = NSMutableAttributedString(attributedString: flowerNumber)
        attributeString.append(description)
        label.attributedText = attributeString
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .aqua
        
        setupTitle()
    }
    
    private func setupTitle() {
        self.addSubview(self.title)
        self.title.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
