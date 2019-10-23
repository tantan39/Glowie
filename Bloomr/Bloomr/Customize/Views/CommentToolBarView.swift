//
//  CommentToolBarView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/24/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import GrowingTextView
import RxCocoa
import RxSwift

enum CommentToolBarState {
    case active
    case normal
}

class CommentToolBarView: BaseView {
    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    var textView: GrowingTextView = {
       let textView =  GrowingTextView(frame: .zero)
        textView.border(borderWidth: 1, cornerRadius: 17.5, borderColor: .light_grey)
        textView.maxLength = 200
        textView.maxHeight = 70
        textView.minHeight = 40.0
        textView.trimWhiteSpaceWhenEndEditing = true
        textView.placeholderLabel.text = "input something....".localized()
        textView.placeholderColor = UIColor.charcoal_grey
        textView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0)
        textView.font = UIFont.fromType(.primary(.regular, .h3))
        return textView
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.aqua, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h3))
        return button
    }()
    
    var state: CommentToolBarState = .normal {
        didSet {
            let title: String = state == .normal ? "15 comments".localized() : TextManager.doneText
            self.doneButton.setTitle(title.localized(), for: .normal)
        }
    }
    
    var addLeftRightPadding: Bool = true {
        didSet {
            self.updatePaddingConstraint()
        }
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .white
        state = .normal
        setupDoneButton()
        setupTextView()
    }
    
    private func setupTextView() {
        self.addSubview(self.textView)
        self.textView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalTo(self.doneButton.snp.leading).offset(-Dimension.shared.mediumHorizontalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.smallVerticalMargin)
            maker.top.equalToSuperview().offset(Dimension.shared.smallVerticalMargin)
        }
    }
    
    private func setupDoneButton() {
        self.addSubview(doneButton)
        self.doneButton.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.width.equalTo(Dimension.shared.smallButtonWidth)
            maker.height.equalTo(Dimension.shared.buttonHeight_40)
            maker.top.equalToSuperview().offset(Dimension.shared.smallVerticalMargin)
        }
    }
    
    private func updatePaddingConstraint() {
        let padding: CGFloat = self.addLeftRightPadding ? Dimension.shared.normalHorizontalMargin : 0
        self.textView.snp.updateConstraints { (maker) in
            maker.leading.equalToSuperview().offset(padding)
        }
        
        self.doneButton.snp.updateConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-padding)
        }
    }
}
