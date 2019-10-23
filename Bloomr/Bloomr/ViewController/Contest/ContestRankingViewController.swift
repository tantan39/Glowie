//
//  ContestRankingViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import SVProgressHUD
class ContestRankingViewController: BaseViewController, GiveFlowerAble {
    var droppableLocations: [SEDraggableLocation]? = [] /*{
        didSet {
            if let locations = droppableLocations, locations.count > 0 {
                _ = locations.map({ AppManager.shared.homeTabBarView?.homeDraggable.addAllowedDrop($0) })
            }
        }
    }*/
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var headerStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    lazy var timeSegmentView: SegmentView = {
        let segment = SegmentView(frame: .zero)
        segment.isHidden = true
        segment.delegate = self
        segment.timeSegmentControl.selectedSegmentIndex = 0
        return segment
    }()
    
    lazy var lineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .light_grey
        return view
    }()
    
    lazy var searchView: RankingSeachView = {
        let view = RankingSeachView(frame: .zero)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.width, height: 65)
        layout.minimumLineSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .white
        collectionView.register(ContestRankingCollectionViewCell.self, forCellWithReuseIdentifier: ContestRankingCollectionViewCell.cellIdentifier())
        collectionView.register(ContestRankingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ContestRankingHeaderView.reuseIdentifier())
        return collectionView
    }()
    
    var viewModel: ContestRankingViewModel = ContestRankingViewModel()
    var documentManager: DocumentManager?
    convenience init(viewModel: ContestRankingViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = .white
        
        setupStackView()
        setupTopStackView()
        setupTimeSegmentView()
        setupLineView()
        setupSearchView()
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.showNavigationBarRightViewStyle(.upload)
        self.title = self.viewModel.contest?.name
        
        if (self.viewModel.contest?.contestType == ContestItemType.country) || (self.viewModel.contest?.contestType == ContestItemType.location) {
            self.timeSegmentView.isHidden = false
            self.viewModel.ckey.accept(ContestTimeRange.daily.rawValue)
        } else {
            self.viewModel.ckey.accept(nil)
        }
        
        handleObservers()
    }
    
    private func setupStackView() {
        self.view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            }
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTopStackView() {
        self.stackView.addArrangedSubview(self.headerStackView)
        self.headerStackView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupTimeSegmentView() {
        self.headerStackView.addArrangedSubview(self.timeSegmentView)
        self.timeSegmentView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(50)
        }
    }
    
    private func setupLineView() {
        self.headerStackView.addArrangedSubview(self.lineView)
        self.lineView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
        }
    }
    
    private func setupSearchView() {
        self.headerStackView.addArrangedSubview(self.searchView)
        self.searchView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(self.timeSegmentView.snp.height)
        }
    }
    
    private func setupCollectionView() {
        self.stackView.addArrangedSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    private func handleObservers() {
        self.customNavigationView?.uploadButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            if self.viewModel.contest?.contestFormat == .audio {
                self.documentManager = DocumentManager()
                self.documentManager?.delegate = self
                self.documentManager?.openDocumentPickerViewController(from: self)
            } else if self.viewModel.contest?.contestFormat == .photo {
                _ = DeviceGalleryRouter().navigate(from: self, transitionType: .present, animated: true)
            } else {
                _ = DeviceGalleryRouter().navigate(from: self, transitionType: .present, animated: true)
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel.banners.subscribe(onNext: { [weak self] (banners) in
            guard let self = self, let _ = banners else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        self.viewModel.ckey.subscribe(onNext: { [weak self] (_) in
            guard let self  = self else { return }
            self.viewModel.getListRanking (completion: {(_, error) in
                if let error = error {
                    self.handle(error)
                    return
                }
                
            })
            self.viewModel.getBanners()
        }).disposed(by: self.disposeBag)
        
        self.viewModel.datasource.subscribe(onNext: { [weak self] (data) in
            guard let self = self, let _ = data else { return }
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        self.viewModel.joinContestSuccess.subscribe(onNext: { [weak self] (result) in
            guard let self = self, result else { return }
            self.viewModel.getListRanking(completion: nil)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.isLoading.subscribe(onNext: { (loading) in
            if loading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: self.disposeBag)
        
        self.searchView.findMyRankButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            let indexPath = IndexPath(row: self.viewModel.myRank.value - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }).disposed(by: self.disposeBag)
    }
}

extension ContestRankingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.width, height: self.view.width * 9/16)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ContestRankingHeaderView.reuseIdentifier(), for: indexPath) as! ContestRankingHeaderView
            view.viewModel = self.viewModel
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.datasource.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestRankingCollectionViewCell.cellIdentifier(), for: indexPath) as? ContestRankingCollectionViewCell, let item = self.viewModel.datasource.value?[indexPath.row] else { fatalError() }
        cell.binding(rank: item.rank, avatar: item.avatar, name: item.displayName, flower: item.flower)
        cell.draggableLocation.index = indexPath
        cell.draggableLocation.delegate = self
        self.droppableLocations?.append(cell.draggableLocation)
        cell.avatarImageView.addTapGestureRecognizer(action: { [weak self] in
            _ = UserProfileRouter(uid: item.uid).navigate(from: self?.navigationController, transitionType: .push, animated: true)
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = ContestAlbumRouter(contest: self.viewModel.contest).navigate(from: self.navigationController, transitionType: .push, animated: true) as? ContestAlbumViewController
    }
}
extension ContestRankingViewController: SegmentViewDelegate {
    func segmentView_didSelected(at index: Int) {
        var timeRange: String = ContestTimeRange.daily.rawValue
        switch index {
        case 0:
            timeRange = ContestTimeRange.daily.rawValue
        case 1:
            timeRange = ContestTimeRange.weekly.rawValue
        case 2:
            timeRange = ContestTimeRange.monthly.rawValue
        case 3:
            timeRange = ContestTimeRange.yearly.rawValue
        default:
            timeRange = ContestTimeRange.daily.rawValue
        }
        self.viewModel.ckey.accept(timeRange)
    }
}

extension ContestRankingViewController: SEDraggableLocationEventResponder {
    func draggableLocation(_ location: SEDraggableLocation!, didAcceptObject object: SEDraggable!, entryMethod method: SEDraggableLocationEntryMethod) {
        AppManager.showExpandingMenu(from: location, style: .cell, homeSelected: {
            self.showCustomFlowerPopup(completion: { [weak self] value in
                guard let self = self else { return }
                self.giveFlowers(value, location)
            })
        }, valueSelected: { number in
            self.giveFlowers(number, location)
        }, storeSelected: {
            
        })
    }

}

extension ContestRankingViewController: DocumentManagerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        _ = UpdatePostContentRouter(viewModel: nil, audioUrl: url.absoluteString).navigate(from: self.navigationController, transitionType: .push, animated: true)
    }
}

extension ContestRankingViewController {
    private func giveFlowers(_ flower: Int, _ location: SEDraggableLocation!) {
        if let indexPath = location.index, let item = self.viewModel.datasource.value?[indexPath.row] {
            self.viewModel.giveFlowerOnRace(flower: flower, uid: item.uid, contest: self.viewModel.contest?.key, ckey: self.viewModel.ckey.value, callback: { (success) in
                if success {
                    self.viewModel.getListRanking(completion: nil)
                    AppManager.showAfterEffect(from: location, style: .cell)
                    
                    let user = UserSessionManager.user()
                    user?.flowers -= flower
                    AppManager.shared.updateFlowerNumber(flower: user?.flowers ?? 0)
                }
            }, failure: { (error) in
                self.handle(error)
            })
        }
    }
}

