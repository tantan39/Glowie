//
//  WinnerClubPageMenu.swift
//  Bloomr
//
//  Created by Tan Tan on 10/6/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxSwift
import RxCocoa
class WinnerClubPageMenu: BaseView {
    lazy var shadowView: ShadowableView = {
        let view = ShadowableView(frame: .zero)
        view.shadowOpacity = 1
        view.shadowColor = .duskyBlue
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(WinnerClubSubMenuCell.self, forCellWithReuseIdentifier: WinnerClubSubMenuCell.cellIdentifier())
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var underLineView: BaseView = {
        let view = BaseView(frame: .zero)
        view.backgroundColor = .orangeRed
        return view
    }()
        
    var viewModel: WinnerClubViewModel? {
        didSet {
            guard let _ = viewModel else { return }
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        }
    }
    
    var subMenuSelectedIndex = BehaviorRelay<IndexPath?>(value: nil)
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupShadow()
        setupCollectionView()
        setupUnderlineView()
    }
    
    private func setupShadow() {
        self.addSubview(shadowView)
        self.shadowView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().offset(2)
        }
    }
    
    private func setupCollectionView() {
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            //            layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3, height: 40)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
        }
    }
    
    private func setupUnderlineView() {
        self.addSubview(self.underLineView)
        self.underLineView.snp.makeConstraints { (maker) in
            maker.leading.bottom.equalToSuperview()
            maker.height.equalTo(2)
            maker.width.equalToSuperview().dividedBy(3)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension WinnerClubPageMenu: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel = self.viewModel else { return .zero}
        return CGSize(width: UIScreen.main.bounds.width/CGFloat(viewModel.datasouce.count), height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.datasouce.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = self.viewModel?.datasouce, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WinnerClubSubMenuCell.cellIdentifier(), for: indexPath) as? WinnerClubSubMenuCell else { return UICollectionViewCell() }
        
        cell.type = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        self.subMenuSelectedIndex.accept(indexPath)
        selectedMenu(at: indexPath.row)
    }
}

// MARK: - Support function
extension WinnerClubPageMenu {
    
    func selectedMenu(at index: Int) {
        self.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .init())
        
        let pading: CGFloat = CGFloat(index) * (self.collectionView.bounds.width/CGFloat(self.viewModel?.datasouce.count ?? 0))
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.underLineView.snp.updateConstraints { (maker) in
                maker.leading.equalToSuperview().offset(pading)
            }
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
