//
//  FlowerShopViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/16/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class FlowerShopViewController: BaseViewController {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        let flowerNumber = NSAttributedString(string: "Hiện tại bạn đang có ", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h2)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        let description = NSAttributedString(string: "4545 HOA", attributes: [
            NSAttributedString.Key.font: UIFont.fromType(.primary(.medium, .h2)),
            NSAttributedString.Key.foregroundColor: UIColor.charcoal_grey])
        
        let attributeString = NSMutableAttributedString(attributedString: flowerNumber)
        attributeString.append(description)
        label.attributedText = attributeString
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(FlowerPackageCell.self, forCellWithReuseIdentifier: FlowerPackageCell.cellIdentifier())
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.reuseIdentifier())
        collectionView.backgroundColor = .veryLightPinkTwo
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var paymentButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle(TextManager.paymentText.localized().uppercased(), for: .normal)
        button.backgroundColor = .aqua
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h3))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Star Shop".localized().uppercased()
        self.view.backgroundColor = .veryLightPinkTwo
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupTitle()
        setupCollectionView()
    }
    
    private func setupTitle() {
        self.view.addSubview(self .titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(Dimension.shared.normalVerticalMargin_20)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8 + Dimension.shared.normalVerticalMargin_20)
            }
//            maker.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin_20)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 3
            layout.minimumInteritemSpacing = 3
            layout.itemSize = CGSize(width: self.view.width, height: 60)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FlowerShopViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionReusableView.reuseIdentifier(), for: indexPath)
            view.addSubview(self.paymentButton)
            self.paymentButton.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_32)
                maker.height.equalTo(Dimension.shared.buttonHeight_55)
                maker.leading.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_40)
                maker.trailing.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin_40)
            }
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlowerPackageCell.cellIdentifier(), for: indexPath) as? FlowerPackageCell else { fatalError() }
        
        return cell
    }
}
