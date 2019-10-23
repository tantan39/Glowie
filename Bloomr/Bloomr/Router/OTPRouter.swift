//
//  OTPRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/23/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct OTPRouter: Router {
    var otpStatus: OTPResult?
    var phone: String?
    init(result: OTPResult?, phone: String?) {
        self.otpStatus = result
        self.phone = phone
    }
    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewController = OTPViewController(status: self.otpStatus, phone: self.phone)
        RoutingExecutor.navigate(from: root, to: viewController, transitionType: transitionType)
        return viewController
    }
}
