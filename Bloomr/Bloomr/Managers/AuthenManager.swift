//
//  AuthenManager.swift
//  Bloomr
//
//  Created by Tan Tan on 10/6/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift
class AuthenManager {
    let disposeBag = DisposeBag()
    func fetchProfile(completionBlock: CompletionBlock?) {
        let api = UserAPI.fetchProfile
        UserAPIProvider.rx.requestGetObject(ofType: User.self, api).subscribe(onNext: { [weak self] (response) in
            guard let _ = self, let response = response else { return }
            if let error = response.error {
                completionBlock?(nil, error)
                return
            }
            if let user = response.result {
                completionBlock?(user, nil)
            }
        }).disposed(by: self.disposeBag)
    }
}
