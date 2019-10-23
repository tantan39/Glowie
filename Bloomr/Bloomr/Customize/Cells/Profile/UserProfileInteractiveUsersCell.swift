//
//  UserProfileInteractiveUsersCell.swift
//  Bloomr
//
//  Created by Tan Tan on 9/18/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

protocol UserProfileInteractiveUsersCellDelegate: class {
    func uploadButton_didPressed()
    func achievementButton_didPressed()
    func viewMoreInteractiveButton_didPressed()
    func flowerShopButton_didPressed()
}

extension UserProfileInteractiveUsersCellDelegate {
    func uploadButton_didPressed() { }
    func achievementButton_didPressed() { }
    func viewMoreInteractiveButton_didPressed() { }
    func flowerShopButton_didPressed() { }
}

class UserProfileInteractiveUsersCell: BaseCollectionViewCell {
    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Dimension.shared.normalVerticalMargin
        return stackView
    }()
    
    let topView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    let flowerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let chatButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.backgroundColor = .deepOrange
        button.setTitle("CHAT".localized(), for: .normal)
        button.setImage(UIImage(named: "chat"), for: .normal)
        button.titleLabel?.font = .fromType(.primary(.bold, .h4_10))
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let achievementButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.backgroundColor = UIColor.dustyOrange
        button.setTitle("ACHIEVEMENT".localized(), for: .normal)
        button.titleLabel?.font = .fromType(.primary(.bold, .h4_10))
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let topInteractiveUsersView: InteractiveUsersView = {
        let view = InteractiveUsersView(frame: .zero)
        return view
    }()
    
    weak var delegate: UserProfileInteractiveUsersCellDelegate?
    let disposeBag = DisposeBag()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .white
        
        setupStackView()
        setupTopView()
        setupFlowerLabel()
        setupChatButton()
        setupAchievementButton()
        setupBottomView()
        
        handleObservers()
    }
    
    private func setupStackView() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupTopView() {
        self.stackView.addArrangedSubview(self.topView)
    }
    
    private func setupFlowerLabel() {
        self.topView.addSubview(self.flowerLabel)
        self.flowerLabel.snp.makeConstraints { (maker) in
            maker.top.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
        }
        self.flowerLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private func setupChatButton() {
        self.topView.addSubview(self.chatButton)
        self.chatButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.flowerLabel)
            maker.leading.equalTo(self.flowerLabel.snp.trailing).offset(Dimension.shared.largeHorizontalMargin)
            maker.width.equalToSuperview().multipliedBy(0.4)
            maker.height.equalTo(Dimension.shared.buttonHeight_35)
            maker.bottom.equalToSuperview()
        }
    }
    
    private func setupAchievementButton() {
        self.topView.addSubview(self.achievementButton)
        self.achievementButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.chatButton)
            maker.leading.equalTo(self.chatButton.snp.trailing).offset(Dimension.shared.smallHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.height.equalTo(Dimension.shared.buttonHeight_35)
        }
    }
    
    private func setupBottomView() {
        self.stackView.addArrangedSubview(self.topInteractiveUsersView)
    }
    
    private func handleObservers() {
        
        self.achievementButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.delegate?.achievementButton_didPressed()
        }).disposed(by: self.disposeBag)
        
        self.topInteractiveUsersView.moreButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.delegate?.viewMoreInteractiveButton_didPressed()
        }).disposed(by: self.disposeBag)
        
        self.chatButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.delegate?.flowerShopButton_didPressed()
        }).disposed(by: self.disposeBag)
    }
}

extension UserProfileInteractiveUsersCell {
    func bindingData(receiverFlower: Int?, followers: Int?, followings: Int?) {
        let flowerNumber = NSAttributedString(string: "\(receiverFlower ?? 0)\n", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.medium, .h1)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        let description = NSAttributedString(string: "Số hoa nhận", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h4_10)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        
        let attributeString = NSMutableAttributedString(attributedString: flowerNumber)
        attributeString.append(description)
        self.flowerLabel.attributedText = attributeString
        
        self.topInteractiveUsersView.followersNumber = followers ?? 0
        self.topInteractiveUsersView.followingsNumber = followings ?? 0
    }
}
