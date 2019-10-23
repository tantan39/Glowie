//
//  WinnerClubMainCell.swift
//  Bloomr
//
//  Created by Tan Tan on 10/6/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift
class WinnerClubMainCell: BaseCollectionViewCell {
    let pageMenu: WinnerClubPageMenu = {
        let view = WinnerClubPageMenu(frame: .zero)
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(WinnerClubListCell.self, forCellWithReuseIdentifier: WinnerClubListCell.cellIdentifier())
//        collectionView.register(AudioContestListCell.self, forCellWithReuseIdentifier: AudioContestListCell.cellIdentifier())
//        collectionView.register(VideoContestListCell.self, forCellWithReuseIdentifier: VideoContestListCell.cellIdentifier())
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var viewModel: WinnerClubViewModel? {
        didSet {
            if let viewModel = viewModel {
                self.pageMenu.viewModel = viewModel
                self.collectionView.reloadData()
            }
        }
    }
    
    var disposeBag = DisposeBag()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .duskyBlue
        setupHeaderMenuView()
        setupCollectionView()
        
        handleObservers()
    }
    
    private func setupHeaderMenuView() {
        self.addSubview(pageMenu)
        self.pageMenu.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(40)
        }
    }
    
    private func setupCollectionView() {
        self.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.pageMenu.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: self.width, height: self.height - 40)
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
        }
        
        self.collectionView.isPagingEnabled = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func handleObservers() {
        self.pageMenu.subMenuSelectedIndex.subscribe(onNext: {[weak self] indexPath in
            guard let self = self, let indexPath = indexPath, self.viewModel?.datasouce != nil else { return }
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }).disposed(by: self.disposeBag)
    }
}

extension WinnerClubMainCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / self.collectionView.width)
        self.pageMenu.selectedMenu(at: index)
    }
}

extension WinnerClubMainCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.datasouce.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contestType = self.viewModel?.datasouce[indexPath.row]
        switch contestType {
        case .bronze:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WinnerClubListCell.cellIdentifier(), for: indexPath) as? WinnerClubListCell else { return UICollectionViewCell() }
//            cell?.homeContestViewModel = self.viewModel
            return cell
        case .silver:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WinnerClubListCell.cellIdentifier(), for: indexPath) as? WinnerClubListCell else { return UICollectionViewCell() }
            //            cell?.homeContestViewModel = self.viewModel
            return cell
        case .gold:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WinnerClubListCell.cellIdentifier(), for: indexPath) as? WinnerClubListCell else { return UICollectionViewCell() }
            //            cell?.homeContestViewModel = self.viewModel
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
