//
//  WinnerClubListCell.swift
//  Bloomr
//
//  Created by Tan Tan on 10/7/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class WinnerClubListCell: BaseCollectionViewCell {
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Dimension.shared.smallVerticalMargin
        return stackView
    }()
    
    lazy var topView: BaseView = {
        let view = BaseView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var searchTextfield: UITextField = {
        let textfield = UITextField(frame: .zero)
        textfield.layer.cornerRadius = 5.0
        textfield.layer.borderColor = UIColor.light_grey.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.font = .fromType(.primary(.italic, .h4))
        textfield.placeholder = "Search name, ranking".localized()
        textfield.textAlignment = .center
        return textfield
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(WinnerClubItemCell.self, forCellWithReuseIdentifier: WinnerClubItemCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupStackView()
        setupTopView()
        setupSearchView()
        setupCollectionView()
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
    
    private func setupSearchView() {
        self.topView.addSubview(self.searchTextfield)
        self.searchTextfield.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin_10)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.height.equalTo(40)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin_10)
        }
    }
    
    private func setupCollectionView() {
        self.stackView.addArrangedSubview(self.collectionView)
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: self.width, height: 65)
        }
    }
    
}

extension WinnerClubListCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WinnerClubItemCell.cellIdentifier(), for: indexPath) as? WinnerClubItemCell else { return UICollectionViewCell() }
        cell.binding()
        return cell
    }
}
