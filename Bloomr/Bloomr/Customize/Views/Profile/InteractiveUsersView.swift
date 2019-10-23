//
//  InteractiveUsersView.swift
//  Bloomr
//
//  Created by Tan Tan on 9/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class InteractiveUsersView: BaseView {
    lazy var pageMenuView: InteractivePageMenu = {
        let view = InteractivePageMenu(frame: .zero)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(FollowersCollectionViewCell.self, forCellWithReuseIdentifier: FollowersCollectionViewCell.cellIdentifier())
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(frame: .zero)

        button.setImage(UIImage(named: "icon-followers-view-more"), for: .normal)
        return button
    }()
    
    lazy var moreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = TextManager.moreText.localized()
        label.textColor = .orangeRed
        label.font = .fromType(.primary(.medium, .h3))
        return label
    }()
    
    var followersNumber: Int = 0 {
        didSet {
            self.pageMenuView.followersNumber = followersNumber
        }
    }
    
    var followingsNumber: Int = 0 {
        didSet {
            self.pageMenuView.followingsNumber = followingsNumber
        }
    }
    
    var dataSource: [String]? {
        didSet {
            if let data = dataSource {
                self.pageMenuView.dataSource = data
                self.collectionView.dataSource = self
                self.collectionView.delegate = self
            }
        }
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupPageMenu()
        setupCollectionView()
        setupMoreButton()
        setupMoreLabel()
    }
    
    private func setupPageMenu() {
        self.addSubview(self.pageMenuView)
        self.pageMenuView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(40)
        }
    }
    
    private func setupCollectionView() {
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.pageMenuView.snp.bottom)
            maker.leading.bottom.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.8)
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
    }
    
    private func setupMoreButton() {
        self.addSubview(self.moreButton)
        self.moreButton.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(Dimension.shared.avatarWidth_45)
            maker.top.equalTo(self.collectionView).offset(Dimension.shared.mediumVerticalMargin)
            maker.leading.equalTo(self.collectionView.snp.trailing)
        }
    }
    
    private func setupMoreLabel() {
        self.addSubview(self.moreLabel)
        self.moreLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.moreButton.snp.bottom)
            maker.centerX.equalTo(self.moreButton)
        }
    }
}

extension InteractiveUsersView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.width/4, height: self.collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowersCollectionViewCell.cellIdentifier(), for: indexPath) as? FollowersCollectionViewCell else { return UICollectionViewCell() }

        return cell
    }
}
