//
//  NotificationListViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 9/14/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
import RxCocoa
import RxSwift
class NotificationListViewModel: BaseViewModel {
    
    var dataSource = BehaviorRelay<[NotificationItem]?>(value: nil)
    
    func fetchNotification(index: Int, limit: Int, completion: CompletionBlock?) {
        let api = NotificationAPI.fetchNotifications(index: index, limit: limit)
        NotificationAPIProvider.rx.requestGetArray(ofType: NotificationItem.self, api, disposeBag: nil, usePaging: true).subscribe(onNext: { [weak self] (response) in
            guard let self = self, let response = response else { return }
            self.dataSource.accept(response.result)
        }).disposed(by: self.disposeBag)
    }
}
