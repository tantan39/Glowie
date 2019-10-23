//
//  BaseViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class BaseViewModel: NSObject {
    let disposeBag = DisposeBag()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    var contestSelected: Contest? {
        return AppManager.shared.selectedContest
    }
    
    override init() {
        
    }
}
