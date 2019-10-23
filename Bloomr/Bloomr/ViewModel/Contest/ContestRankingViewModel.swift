//
//  ContestRankingViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/24/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift

enum ContestTimeRange: String {
    case daily = "d"
    case weekly = "w"
    case monthly = "m"
    case yearly = "y"
}

class ContestRankingViewModel: BaseViewModel {
    var contest: Contest?
    var datasource = BehaviorRelay<[RankItem]?>(value: nil)
    var banners = BehaviorRelay<[ContestBanner]?>(value: nil)
    var ckey = BehaviorRelay<String?>(value: nil)
    var gender: Gender = .none
    var joinContestSuccess = BehaviorRelay<Bool>(value: false)
    var myRank = BehaviorRelay<Int>(value: 0)
    var index: Int = 0
    
    func getListRanking(completion: CompletionBlock?) {
        guard let contest = self.contest else { return }
        let ckey = ((contest.contestType == .country) || (contest.contestType == .location)) ? self.ckey.value : nil
        self.isLoading.accept(true)
        let api = ContestAPI.getListRanking(contest: contest.key, gender: AppManager.shared.selectedGender.toInt(), ckey: ckey)
        let request = ContestAPIProvider.rx.request(api, disposeBag: nil, callbackQueue: nil, keypath: nil)
        request.subscribe(onNext: { [weak self] (response) in
            guard let self = self, let response = response else { return }
            self.isLoading.accept(false)
            if let error = response.error {
                completion?(nil, error)
            }
            
            if let json = response.json {
                let list = json[Constant.defaultKeypathForArray].arrayValue
                let result = list.compactMap({ RankItem(json: $0) })
                self.datasource.accept(result)
                
                let ranking = json["myRank"].intValue
                self.myRank.accept(ranking)
            }
        
        }).disposed(by: self.disposeBag)
    }
    
    func getBanners() {
        guard let contest = self.contest else { return }
        let ckey = ((contest.contestType == .country) || (contest.contestType == .location)) ? self.ckey.value : nil
        let api = ContestAPI.getContestBanners(contest: contest.key, gender: AppManager.shared.selectedGender.toInt(), ckey: ckey)
        let request = ContestAPIProvider.rx.requestGetArray(ofType: ContestBanner.self, api)

        request.subscribe(onNext: { [weak self] (response) in
            guard let self = self, let result = response?.result else { return }
            self.banners.accept(result)
        }).disposed(by: self.disposeBag)
    }
    
    func giveFlowerOnRace(flower: Int, uid: Int?, contest: String?, ckey: String?, callback: ((Bool) -> Void)?, failure: ((ServiceErrorAPI) -> Void)?) {
        self.isLoading.accept(true)
        let api = FlowerAPI.giveFlowerOnRace(flower: flower, contest: contest ?? "", ckey: ckey ?? "", model: uid ?? 0)
        FlowerAPIProvider.rx.requestCheckResult(api).subscribe(onNext: { (response) in
            guard let response = response else { return }
            self.isLoading.accept(false)
            if let error = response.error {
                failure?(error)
            }
            
            if response.result {
                callback?(response.result)
            }
        }).disposed(by: self.disposeBag)
    }
}
