//
//  WinnerClubViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 10/6/19.
//  Copyright © 2019 phdv. All rights reserved.
//

enum WinnerType {
    case bronze
    case silver
    case gold
}

import Foundation
import RxSwift
import RxCocoa

class WinnerClubViewModel: BaseViewModel {
    var datasouce: [WinnerType] = [.bronze, .silver, .gold]
}
