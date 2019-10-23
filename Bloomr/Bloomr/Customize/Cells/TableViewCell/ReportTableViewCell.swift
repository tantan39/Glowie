//
//  ReportTableViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/27/19.
//  Copyright © 2019 phdv. All rights reserved.
//

enum ContentType {
    case title
    case content
    case end
}

class ReportTableViewCell: BaseTableViewCell {
    let content: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.regular, .h3))
        label.textColor = .charcoal_grey
        return label
    }()
    
    let bottomLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .veryLightPinkTwo
        return view
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupContentLabel()
        setupBottomLineView()
    }
    
    private func setupContentLabel() {
        self.addSubview(self.content)
        self.content.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            maker.centerY.equalToSuperview()
        }
    }
    
    private func setupBottomLineView() {
        self.addSubview(bottomLine)
        self.bottomLine.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.content)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(1)
        }
    }
    
    func setTitle(_ text: String, type: ContentType) {
        var font: UIFont?
        var color: UIColor?
        switch type {
        case .end:
            font = .fromType(.primary(.regular, .h4_10))
            color = .gray
        case .title:
            font = .fromType(.primary(.medium, .h1))
            color = .black
        default:
            font = .fromType(.primary(.regular, .h2))
            color = .charcoal_grey
        }
        
        self.content.text = text
        self.content.font = font
        self.content.textColor = color
    }
}
