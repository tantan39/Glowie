//
//  ProfileStatusCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/4/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ProfileStatusCollectionViewCellDelegate: class {
    func editAvatarButton_didPressed()
}

extension ProfileStatusCollectionViewCellDelegate {
    func editAvatarButton_didPressed() { }
}

class ProfileStatusCollectionViewCell: BaseCollectionViewCell {
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Dimension.shared.normalVerticalMargin
        return stackView
    }()
    
    lazy var userInfoView: UserInfoView = {
        let view = UserInfoView(frame: .zero)
        return view
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.regular, .h3))
        label.textColor = .black70
        label.numberOfLines = 0
        label.text = "Hôm nay trời nắng đẹp, mình thì đẹp hơn nắng đúng hơm cả nhà! Hôm nay trời nắng đẹp, mình thì đẹp… Xem thêm "
        return label
    }()
    
    lazy var userCommentView: UserCommentView = {
        let view = UserCommentView(frame: .zero)
        return view
    }()
    
    lazy var inputCommentView: CommentToolBarView = {
        let view = CommentToolBarView(frame: .zero)
        view.addLeftRightPadding = false
        view.textView.delegate = self
        return view
    }()
    
    weak var delegate: ProfileStatusCollectionViewCellDelegate?
    let disposeBag = DisposeBag()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .white
        
        setupStackView()
        setupUserInfoView()
        setupStatusLabel()
        setupUserCommentView()
        setupInputCommentView()
        
        handleObservers()
    }
    
    private func setupStackView() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupUserInfoView() {
        self.stackView.addArrangedSubview(self.userInfoView)
        self.userInfoView.snp.makeConstraints { (maker) in
            maker.height.equalTo(70)
        }
    }
    
    private func setupStatusLabel() {
        self.stackView.addArrangedSubview(self.statusLabel)
    }
    
    private func setupUserCommentView() {
        self.stackView.addArrangedSubview(self.userCommentView)
    }
    
    private func setupInputCommentView() {
        self.stackView.addArrangedSubview(self.inputCommentView)
    }
    
    private func handleObservers() {
        self.userInfoView.uploadButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.delegate?.editAvatarButton_didPressed()
        }).disposed(by: self.disposeBag)
    }
}

extension ProfileStatusCollectionViewCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == self.inputCommentView.textView {
//            _ = DetailStatusRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
            return false
        }
        return true
    }
}

extension ProfileStatusCollectionViewCell {
    func binding(_ user: User) {
        self.userInfoView.setInfo(name: user.displayName, location: user.location, avatarUrl: user.avatar)
    }
}
