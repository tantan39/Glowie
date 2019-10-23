//
//  SingingContestViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 9/23/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift
class SingingContestViewModel: BaseViewModel {
    var categories = BehaviorRelay<[ContestItemType]>(value: [])
    var contests = BehaviorRelay<[Contest]>(value: [])
    var availableContest = BehaviorRelay<AvailableContest?>(value: nil)
    var selectedContest: BehaviorRelay<Contest?> = BehaviorRelay<Contest?>(value: nil)
    
    override init() {
        super.init()
    }
    
    func getAvailableContests(callback: ((ServiceErrorAPI?) -> Void)?) {
        let request = ContestAPI.getAvailableContests(gender: AppManager.shared.selectedGender.toInt(), type: ContestType.singing.rawValue)
        ContestAPIProvider.rx.requestGetObject(ofType: AvailableContest.self, request).subscribe(onNext: { [weak self] (response) in
            guard let self = self else { return }
            if let error = response?.error {
                callback?(error)
            }
            
            if let object = response?.result {
                self.availableContest.accept(object)
                self.categories.accept(object.categories)
                self.contests.accept(object.contests)
            }
        }).disposed(by: self.disposeBag)
    }
}
