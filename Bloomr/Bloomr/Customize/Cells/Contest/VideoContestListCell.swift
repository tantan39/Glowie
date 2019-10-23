//
//  VideoContestListCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/24/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift
class VideoContestListCell: BaseCollectionViewCell {
    private var headerView: ContestHeaderBannerView = {
        let view = ContestHeaderBannerView(frame: .zero)
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor(white: 0, alpha: 0.03)
        collectionView.register(VideoContestCollectionViewCell.self, forCellWithReuseIdentifier: VideoContestCollectionViewCell.cellIdentifier())
        return collectionView
    }()
    
    var disposeBag = DisposeBag()
    var homeContestViewModel: HomeContestViewModel? {
        didSet {
            self.handleObservers()
            self.homeContestViewModel?.modelingContestViewModel?.getAvailableContests(callback: { (error) in
                guard let error = error else { return }
                AlertManager.shared.show(message: error.reason)
            })
        }
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.bottom.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 4
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        }
        
        // Set image ratio 16:9
        let headerViewHeight = self.width * 9/16
        
        self.collectionView.contentInset = UIEdgeInsets(top: headerViewHeight, left: 0, bottom: 0, right: 0)
        
        headerView = ContestHeaderBannerView(frame: CGRect(x: 0, y: -headerViewHeight, width: self.width, height: headerViewHeight))
        self.collectionView.addSubview(headerView)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func handleObservers() {
        self.homeContestViewModel?.modelingContestViewModel?.categories.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        self.homeContestViewModel?.modelingContestViewModel?.contests.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
    }
}

extension VideoContestListCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Height cell = topView + centerView + bottomView
        return CGSize(width: self.width, height: self.width * 9/16 + (50 * 2))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.homeContestViewModel?.modelingContestViewModel?.categories.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = self.homeContestViewModel?.modelingContestViewModel?.categories.value[section]
        switch category {
        case .modeling?:
            return self.homeContestViewModel?.modelingContestViewModel?.availableContest.value?.modelingContests.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = self.homeContestViewModel?.modelingContestViewModel?.categories.value[indexPath.section]
        let availableContest = self.homeContestViewModel?.modelingContestViewModel?.availableContest.value
        var contest: Contest?
        switch category {
        case .modeling?:
            contest = availableContest?.modelingContests[indexPath.row]
        default:
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoContestCollectionViewCell.cellIdentifier(), for: indexPath) as? VideoContestCollectionViewCell
        cell?.binding(categoryName: contest?.categoryName, title: contest?.name, bannerURL: contest?.avatar)
        cell?.uploadButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            let item = self.homeContestViewModel?.modelingContestViewModel?.contests.value[indexPath.section]
            self.homeContestViewModel?.uploadPressed.accept(item)
        }).disposed(by: self.disposeBag)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.homeContestViewModel?.modelingContestViewModel?.availableContest.value?.modelingContests[indexPath.row]
        self.homeContestViewModel?.modelingContestViewModel?.selectedContest.accept(item)
    }
}
