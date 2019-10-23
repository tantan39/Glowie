//
//  ContestAlbumViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift
class ContestAlbumViewModel: BaseViewModel {
    
    var dataSouce = BehaviorRelay<[GalleryThumbnail]?>(value: nil)
    var contest: Contest?
    var seletecPost = BehaviorRelay<GalleryThumbnail?>(value: nil)
    var pagingIndex: Int = 0
    var limit: Int = 10
    
    func getAlbumContest(completion: CompletionBlock?) {
        guard let contest = self.contest, pagingIndex != Constant.lastIndex else { return }
        let api = ContestAPI.getAlbumContest(contest: contest.key, gender: AppManager.shared.selectedGender.toInt(), index: self.pagingIndex, limit: self.limit)
        ContestAPIProvider.rx.requestGetArray(ofType: GalleryThumbnail.self, api, usePaging: true).subscribe(onNext: { [weak self] (response) in
            guard let self = self, let response = response else { return }
            if let error = response.error {
                completion?(nil, error)
                return
            }
            
            if let paging = response.pagination {
                self.pagingIndex = paging.index
            }
            
            if var dataSource = self.dataSouce.value {
                dataSource += response.result
                self.dataSouce.accept(dataSource)
            } else {
                self.dataSouce.accept(response.result)
            }
        }).disposed(by: self.disposeBag)
        
    }
}
