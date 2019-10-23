//
//  LoginViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 10/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import CryptoSwift
import RxCocoa
import RxSwift
class LoginViewModel: BaseViewModel {
    
    var phoneNumber = BehaviorRelay<String?>(value: nil)
    var password = BehaviorRelay<String?>(value: nil)
        
    func login(phone: String?, password: String?, completion: CompletionBlock?) {
        guard let phone = phone, let password = password else { return }
        let randomString = String.random()
        let md5Password = password.md5()
        let data = phone + "+|+" + md5Password
        
        let encryptedSecretClient = randomString.encryptDES(byKey: Constant.appKey, iv: Constant.secretKey)
        let encryptedCridential = data.encryptDES(byKey: Constant.appKey, iv: randomString)
        
        self.isLoading.accept(true)
        let api = AuthenAPI.login(secret: encryptedSecretClient, countryID: Constant.countryID, appID: Constant.appID, credential: encryptedCridential, notification_token: "")
        AuthenAPIProvider.rx.request(api).subscribe(onNext: { (response) in
            guard let response = response else { return }
            self.isLoading.accept(false)
            if let error = response.error {
                completion?(nil, error)
                return
            }
            
            if let json = response.json, let user = User(json: json["item"]["user"]) {
                let auth = json["item"]["auth"]
                UserSessionManager.access_token = auth["access_token"].stringValue
                completion?( user, nil)
            }
        }).disposed(by: self.disposeBag)
        
    }
    
    func fetchProfile(completionBlock: CompletionBlock?) {
        let api = UserAPI.fetchProfile
        self.isLoading.accept(true)
        UserAPIProvider.rx.requestGetObject(ofType: User.self, api).subscribe(onNext: { [weak self] (response) in
            guard let self = self, let response = response else { return }
            self.isLoading.accept(false)
            if let error = response.error {
                completionBlock?(nil, error)
                return
            }
            if let user = response.result {
                UserSessionManager.saveUser(user)
                completionBlock?(user, nil)
            }
        }).disposed(by: self.disposeBag)
    
    }
}
