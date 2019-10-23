//
//  InteractivePageMenu.swift
//  Bloomr
//
//  Created by Tan Tan on 9/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//

protocol InteractivePageMenuDelegate: class {
    func pageMenu_didSelected(at index: Int)
}

extension InteractivePageMenuDelegate {
    func pageMenu_didSelected(at index: Int) { }
}

class InteractivePageMenu: BaseView {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.border(borderWidth: 1, cornerRadius: 0, borderColor: .light_grey)
        collectionView.register(InteractiveUsersPageMenuCell.self, forCellWithReuseIdentifier: InteractiveUsersPageMenuCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .charcoal_grey
        return view
    }()
    
    weak var delegate: InteractivePageMenuDelegate?
    
    var followersNumber: Int?
    var followingsNumber: Int?
    
    var dataSource: [Any]? {
        didSet {
            if dataSource != nil {
                self.collectionView.dataSource = self
                self.collectionView.delegate = self
                self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
            }
        }
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.layoutIfNeeded()
        
        setupCollectionView()
        setupBottomLine()
    }
    
    private func setupCollectionView() {
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-1.5)
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: Dimension.shared.widthScreen/2, height: 40)
        }
    }
    
    private func setupBottomLine() {
        self.addSubview(self.bottomLine)
        self.bottomLine.snp.makeConstraints { (maker) in
            maker.leading.bottom.equalToSuperview()
            maker.height.equalTo(1.5)
            maker.width.equalToSuperview().multipliedBy(0.5)
        }
    }
}

extension InteractivePageMenu: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InteractiveUsersPageMenuCell.cellIdentifier(), for: indexPath) as? InteractiveUsersPageMenuCell else { return UICollectionViewCell() }
        var title: String?
        let index = indexPath.row
        switch index {
        case 0:
            title = self.dataSource?[index] as? String
            if let followers = self.followersNumber {
                title?.append(" (\(followers))")
            }
        case 1:
            title = self.dataSource?[index] as? String
            if let followings = self.followingsNumber {
                title?.append(" (\(followings))")
            }
        default: break
        }
        cell.titleLabel.text = title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.pageMenu_didSelected(at: indexPath.row)
        self.bottomLine.snp.updateConstraints { (maker) in
            maker.leading.equalTo(collectionView.contentSize.width / 2 * CGFloat(indexPath.row))
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.layoutSubviews()
        }, completion: nil)
    }
    
}
