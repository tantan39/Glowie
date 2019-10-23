//
//  MainContestCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/11/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class MainContestListCell: BaseCollectionViewCell {
    private var headerView: ContestHeaderBannerView = {
        let view = ContestHeaderBannerView(frame: .zero)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor(white: 0, alpha: 0.03)
        collectionView.register(ContestCollectionViewCell.self, forCellWithReuseIdentifier: ContestCollectionViewCell.cellIdentifier())
        collectionView.register(LocationItemLayoutCell.self, forCellWithReuseIdentifier: LocationItemLayoutCell.cellIdentifier())
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    var disposeBag = DisposeBag()
    var homeContestViewModel: HomeContestViewModel? {
        didSet {
            self.handleObservers()
            self.homeContestViewModel?.mainContestViewModel?.getAvailableContests(callback: { (error) in
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
        
        // resize image ratio 16:9
        let headerViewHeight = self.width * 9/16
        
        self.collectionView.contentInset = UIEdgeInsets(top: headerViewHeight, left: 0, bottom: 0, right: 0)

        headerView = ContestHeaderBannerView(frame: CGRect(x: 0, y: -headerViewHeight, width: self.width, height: headerViewHeight))
        self.collectionView.addSubview(headerView)
    
    }
    
    private func handleObservers() {
        self.homeContestViewModel?.mainContestViewModel?.categories.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        self.homeContestViewModel?.mainContestViewModel?.contests.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
    }
}

extension MainContestListCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let category = self.homeContestViewModel?.mainContestViewModel?.categories.value[indexPath.section]
        switch category {
        case .location?:
            return CGSize(width: self.width, height: self.width/2 + 50)
        default:
            // Height cell = topView + centerView + bottomView
            return CGSize(width: self.width, height: self.width * 9/16 + (50 * 2))
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.homeContestViewModel?.mainContestViewModel?.categories.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = self.homeContestViewModel?.mainContestViewModel?.categories.value[section]
        switch category {
        case .country?, .location?:
            return 1
        case .sponsor?:
            return self.homeContestViewModel?.mainContestViewModel?.availableContest.value?.sponsorContests.count ?? 0
        case .theme?:
            return self.homeContestViewModel?.mainContestViewModel?.availableContest.value?.themeContests.count ?? 0
        default:
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = self.homeContestViewModel?.mainContestViewModel?.categories.value[indexPath.section]
        let availableContest = self.homeContestViewModel?.mainContestViewModel?.availableContest.value
        var contest: Contest?
        
        switch category {
        case .country?:
            contest = availableContest?.countryContests[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestCollectionViewCell.cellIdentifier(), for: indexPath) as? ContestCollectionViewCell
            cell?.binding(categoryName: contest?.categoryName, title: contest?.name, bannerURL: contest?.avatar)
            cell?.uploadButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.homeContestViewModel?.uploadPressed.accept(contest)
            }).disposed(by: self.disposeBag)
            return cell ?? UICollectionViewCell()
            
        case .location?:
//            contest = availableContest?.locationContests[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationItemLayoutCell.cellIdentifier(), for: indexPath) as? LocationItemLayoutCell
            cell?.homeContestViewModel = self.homeContestViewModel
            
            return cell ?? UICollectionViewCell()
            
        case .sponsor?:
            contest = availableContest?.sponsorContests[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestCollectionViewCell.cellIdentifier(), for: indexPath) as? ContestCollectionViewCell
            cell?.binding(categoryName: contest?.categoryName, title: contest?.name, bannerURL: contest?.avatar)
            cell?.uploadButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.homeContestViewModel?.uploadPressed.accept(contest)
            }).disposed(by: self.disposeBag)
            return cell ?? UICollectionViewCell()
            
        case .theme?:
            contest = availableContest?.themeContests[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestCollectionViewCell.cellIdentifier(), for: indexPath) as? ContestCollectionViewCell
            cell?.binding(categoryName: contest?.categoryName, title: contest?.name, bannerURL: contest?.avatar)
            cell?.uploadButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.homeContestViewModel?.uploadPressed.accept(contest)
            }).disposed(by: self.disposeBag)
            return cell ?? UICollectionViewCell()
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = self.homeContestViewModel?.mainContestViewModel?.contests.value[indexPath.section]
//        self.homeContestViewModel?.mainContestViewModel?.selectedContest.accept(item)
//        
        let category = self.homeContestViewModel?.mainContestViewModel?.categories.value[indexPath.section]
        let availableContest = self.homeContestViewModel?.mainContestViewModel?.availableContest.value
        var contest: Contest?
        
        switch category {
        case .country?:
            contest = availableContest?.countryContests[indexPath.row]
        case .location?:
            contest = availableContest?.locationContests[indexPath.row]
        case .sponsor?:
            contest = availableContest?.sponsorContests[indexPath.row]
        case .theme?:
            contest = availableContest?.themeContests[indexPath.row]
        default:
            break
        }
        self.homeContestViewModel?.mainContestViewModel?.selectedContest.accept(contest)
    }
}
