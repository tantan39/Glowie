//
//  HomeContestViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

class HomeContestViewModel: BaseViewModel {
    
    let dataSouce: [String] = ["CONTEST".localized(), "WINNER CLUB".localized()]
    
    var contestListCollectionViewModel: ContestListCollectionViewModel?
    var winnerClubViewModel: WinnerClubViewModel?
    var mainContestViewModel: MainContestViewModel?
    var singingContestViewModel: SingingContestViewModel?
    var modelingContestViewModel: ModelingContestViewModel?
    
    var contestInfoPressed = BehaviorRelay<Void?>(value: nil)
    var gender = BehaviorRelay<Gender>(value: .female)
    var uploadPressed = BehaviorRelay<Contest?>(value: nil)
    
    override init() {
        super.init()
        
        self.contestListCollectionViewModel = ContestListCollectionViewModel()
        self.winnerClubViewModel = WinnerClubViewModel()
        self.mainContestViewModel = MainContestViewModel()
        self.singingContestViewModel = SingingContestViewModel()
        self.modelingContestViewModel = ModelingContestViewModel()
        
        self.handleObservers()
    }
    
    private func handleObservers() {
        self.gender.subscribe(onNext: { (gender) in
            AppManager.shared.selectedGender = gender
        }).disposed(by: self.disposeBag)
    }
}
