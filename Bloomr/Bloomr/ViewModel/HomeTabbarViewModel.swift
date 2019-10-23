//
//  HomeTabbarViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 9/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxSwift
import RxCocoa

class HomeTabbarViewModel: BaseViewModel {
    var user = BehaviorRelay<User?>(value: nil)
    override init() {
        self.user.accept(UserSessionManager.user())
    }
}
