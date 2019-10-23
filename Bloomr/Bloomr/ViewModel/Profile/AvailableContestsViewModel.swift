//
//  AvailableContestsViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 9/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxSwift
import RxCocoa

class AvailableContestsViewModel: BaseViewModel {
    var contests = BehaviorRelay<[String]?>(value: nil)
    
    override init() {
        super.init()
        
        let data = ["Cuộc thi HỒ CHÍ MINH", "Cuộc thi SHINHAN BANK", "Cuộc thi hát HÃY TRAO CHO ANH", "Cuộc thi VÕ TẮC THIÊN", "Cuộc thi TRUNG THU CHUNG VUI"]
        self.contests.accept(data)
    }
    
}
