//
//  BaseTextField.swift
//  Bloomr
//
//  Created by Tan Tan on 9/23/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class BaseTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: Dimension.shared.normalHorizontalMargin, bottom: 0, right: Dimension.shared.normalHorizontalMargin)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customizeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeUI() {
        self.border(borderWidth: 1, cornerRadius: 0, borderColor: .light_grey)
        self.textColor = .charcoal_grey
        self.font = .fromType(.primary(.regular, .h3))
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
