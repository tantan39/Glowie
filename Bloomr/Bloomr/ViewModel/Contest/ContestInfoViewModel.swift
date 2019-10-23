//
//  ContestInfoViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 9/22/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift
class ContestInfoViewModel: BaseViewModel {
    let joinContestSuccess = BehaviorRelay<Bool>(value: false)
    
    func joinContest(callback: ((ServiceErrorAPI?) -> Void)?) {
        let contest = AppManager.shared.selectedContest
        let api = ContestAPI.joinRace(key: contest?.key ?? "", media_id: "")
        ContestAPIProvider.rx.requestCheckResult(api).subscribe(onNext: { [weak self] (response) in
            guard let self = self else { return }
            if let error = response?.error {
                callback?(error)
            }
            
            if let success = response?.result {
                self.joinContestSuccess.accept(success)
            }
        }).disposed(by: self.disposeBag)
    }
    
}
