//
//  OTPViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 10/6/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxSwift
import RxCocoa
class OTPViewModel: BaseViewModel {
    var otpStatus: OTPResult?
    var otpCode = BehaviorRelay<String?>(value: nil)
    var phone = BehaviorRelay<String?>(value: nil)
    
    init(_ status: OTPResult?, _ phone: String?) {
        self.otpStatus = status
        self.phone.accept(phone)
    }
    
    func verifyOTP(_ code: String?, completion: CompletionBlock?) {
        guard let code = code, let m_id = self.otpStatus?.m_id else { return }
        let randomString = String.random()
        let data = "\(m_id)" + "+|+" + code
        
        let secretClient = randomString.encryptDES(byKey: Constant.appKey, iv: Constant.secretKey)
        let cridential = data.encryptDES(byKey: Constant.appKey, iv: randomString)
        
        self.isLoading.accept(true)
        // Request verify code login if mobile exits else request verify code register
        if let status = self.otpStatus, status.verified {
            
            let api = AuthenAPI.verifyOTPLogin(secret: secretClient, appID: Constant.appID, countryID: Constant.countryID, credential: cridential, notification_token: "")
            AuthenAPIProvider.rx.request(api).subscribe(onNext: { [weak self] (response) in
                guard let self = self, let response = response else { return }
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
            
        } else {
            let api = AuthenAPI.verifyOTPRegister(secret: secretClient, appID: Constant.appID, credential: cridential, notification_token: "")
            AuthenAPIProvider.rx.request(api).subscribe(onNext: { [weak self] (response) in
                guard let self = self, let response = response else { return }
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
