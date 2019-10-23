//
//  ContestViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/10/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class HomeContestViewController: BaseViewController {
    private let headerMenuView: ContestHeaderMenuView = {
        let view = ContestHeaderMenuView(frame: .zero)
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(ContestListCollectionViewCell.self, forCellWithReuseIdentifier: ContestListCollectionViewCell.cellIdentifier())
        collectionView.register(WinnerClubMainCell.self, forCellWithReuseIdentifier: WinnerClubMainCell.cellIdentifier())
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.cellIdentifier())
        return collectionView
    }()
    
    let headerViewHeight: CGFloat = 40.0
    
    var viewModel = HomeContestViewModel()
    var documentManager: DocumentManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        view.backgroundColor = .white
        setupHeaderMenuView()
        setupCollectionView()
    }
    
    private func handleObservers() {
        self.headerMenuView.menuSelectedIndex.subscribe(onNext: { [weak self] (indexPath) in
            guard let self = self, let indexPath = indexPath else { return }
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }).disposed(by: self.disposeBag)
        
        self.headerMenuView.genderButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            let gender = self.viewModel.gender.value
            if gender == .male {
                self.viewModel.gender.accept(.female)
                self.headerMenuView.switchGender(gender: .female)
            } else {
                self.viewModel.gender.accept(.male)
                self.headerMenuView.switchGender(gender: .male)
            }
            self.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
        }).disposed(by: self.disposeBag)
        
        self.viewModel.mainContestViewModel?.selectedContest.subscribe (onNext: { [weak self] (item) in
            guard let self = self, let item = item else { return }
            AppManager.shared.selectedContest = item
            let contestRanking = ContestRankingRouter().navigate(from: self.navigationController, transitionType: .push, animated: true) as? ContestRankingViewController
            contestRanking?.viewModel.contest = item
        }).disposed(by: self.disposeBag)
        
        self.viewModel.singingContestViewModel?.selectedContest.subscribe (onNext: { [weak self] (item) in
            guard let self = self, let item = item else { return }
            AppManager.shared.selectedContest = item
            let contestRanking = ContestRankingRouter().navigate(from: self.navigationController, transitionType: .push, animated: true) as? ContestRankingViewController
            contestRanking?.viewModel.contest = item
        }).disposed(by: self.disposeBag)
        
        self.viewModel.modelingContestViewModel?.selectedContest.subscribe (onNext: { [weak self] (item) in
            guard let self = self, let item = item else { return }
            AppManager.shared.selectedContest = item
            let contestRanking = ContestRankingRouter().navigate(from: self.navigationController, transitionType: .push, animated: true) as? ContestRankingViewController
            contestRanking?.viewModel.contest = item
        }).disposed(by: self.disposeBag)
        
        self.viewModel.uploadPressed.subscribe(onNext: { [weak self] (contest) in
            guard let self = self, let item = contest else { return }
            AppManager.shared.selectedContest = item
            if item.contestFormat == .audio {
                let contestRanking = ContestRankingRouter().navigate(from: self.navigationController, transitionType: .push, animated: false, completion: {
                    self.documentManager = DocumentManager()
                    self.documentManager?.openDocumentPickerViewController(from: self)
                }) as? ContestRankingViewController
                contestRanking?.viewModel.contest = item
            } else if item.contestFormat == .photo {
                let contestRanking = ContestRankingRouter().navigate(from: self.navigationController, transitionType: .push, animated: false, completion: {
                    _ = DeviceGalleryRouter().navigate(from: self, transitionType: .present, animated: false)
                }) as? ContestRankingViewController
                contestRanking?.viewModel.contest = item
            } else {
                let contestRanking = ContestRankingRouter().navigate(from: self.navigationController, transitionType: .push, animated: false, completion: {
                    _ = DeviceGalleryRouter().navigate(from: self, transitionType: .present, animated: false)
                }) as? ContestRankingViewController
                contestRanking?.viewModel.contest = item
            }
        }).disposed(by: self.disposeBag)
    }
}

extension HomeContestViewController {
    private func setupHeaderMenuView() {
        self.view.addSubview(self.headerMenuView)
        self.headerMenuView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(headerViewHeight)
        }
        
        self.headerMenuView.dataSource = self.viewModel.dataSouce
        let gender = self.viewModel.gender.value
        self.headerMenuView.switchGender(gender: gender)
    }
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.headerMenuView.snp.bottom)
            maker.bottom.leading.trailing.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: self.view.width, height: self.view.height - UIApplication.shared.statusBarFrame.height - headerViewHeight)
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
        }
        self.collectionView.isPagingEnabled = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
}

extension HomeContestViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / self.collectionView.width)
        self.headerMenuView.selectedMenu(at: index)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeContestViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSouce.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestListCollectionViewCell.cellIdentifier(), for: indexPath) as? ContestListCollectionViewCell else { return UICollectionViewCell() }
            cell.homeContestViewModel = self.viewModel
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WinnerClubMainCell.cellIdentifier(), for: indexPath) as? WinnerClubMainCell else { return UICollectionViewCell() }
            cell.viewModel = self.viewModel.winnerClubViewModel
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}
