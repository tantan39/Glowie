//
//  AudioContestCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/24/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift
class AudioContestListCell: BaseCollectionViewCell {
    private var headerView: ContestHeaderBannerView = {
        let view = ContestHeaderBannerView(frame: .zero)
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor(white: 0, alpha: 0.03)
        collectionView.register(AudioContestCollectionViewCell.self, forCellWithReuseIdentifier: AudioContestCollectionViewCell.cellIdentifier())
        return collectionView
    }()
    
    var disposeBag = DisposeBag()
    var homeContestViewModel: HomeContestViewModel? {
        didSet {
            self.handleObservers()
            self.homeContestViewModel?.singingContestViewModel?.getAvailableContests(callback: { (error) in
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
        self.homeContestViewModel?.singingContestViewModel?.categories.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        self.homeContestViewModel?.singingContestViewModel?.contests.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
    }
}

extension AudioContestListCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Height cell = topView + centerView + bottomView
        return CGSize(width: self.width, height: self.width * 9/16 + (50 * 2))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.homeContestViewModel?.singingContestViewModel?.categories.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = self.homeContestViewModel?.singingContestViewModel?.categories.value[section]
        switch category {
        case .singing?:
            return self.homeContestViewModel?.singingContestViewModel?.availableContest.value?.singingContests.count ?? 0
        case .hidden_face?:
            return self.homeContestViewModel?.singingContestViewModel?.availableContest.value?.hiddenFaceContests.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = self.homeContestViewModel?.singingContestViewModel?.categories.value[indexPath.section]
        let availableContest = self.homeContestViewModel?.singingContestViewModel?.availableContest.value
        var contest: Contest?
        switch category {
        case .singing?:
            contest = availableContest?.singingContests[indexPath.row]
        case .hidden_face?:
            contest = availableContest?.hiddenFaceContests[indexPath.row]
        default:
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioContestCollectionViewCell.cellIdentifier(), for: indexPath) as? AudioContestCollectionViewCell else { return UICollectionViewCell() }
        cell.binding(categoryName: contest?.categoryName, title: contest?.name, bannerURL: contest?.avatar)
        cell.uploadButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            let item = contest
            self.homeContestViewModel?.uploadPressed.accept(item)
        }).disposed(by: cell.disposeBag)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = self.homeContestViewModel?.singingContestViewModel?.categories.value[indexPath.section]
        let availableContest = self.homeContestViewModel?.singingContestViewModel?.availableContest.value
        var contest: Contest?
        
        switch category {
        case .singing?:
            contest = availableContest?.singingContests[indexPath.row]
        case .hidden_face?:
            contest = availableContest?.hiddenFaceContests[indexPath.row]
        default:
            break
        }
        self.homeContestViewModel?.singingContestViewModel?.selectedContest.accept(contest)
    }
}
