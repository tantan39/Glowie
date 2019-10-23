//
//  RegisterViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 10/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxSwift
import RxCocoa

class RegisterViewModel: BaseViewModel {
    var phoneNumber = BehaviorRelay<String?>(value: nil)
    func requestOTP(completion: CompletionBlock?) {
        guard let phone = self.phoneNumber.value else { return }
        let api = AuthenAPI.getOTP(mobile: phone, countryID: Constant.countryID)
        AuthenAPIProvider.rx.request(api).subscribe(onNext: { (response) in
            if let error = response?.error {
                completion?(nil, error)
                return
            }
            
            if let json = response?.json {
                let item = json["item"]
                completion?((verified: item["state"].boolValue, m_id: item["m_id"].intValue), nil)
            }
        }).disposed(by: self.disposeBag)
    }
}
