//
//  MyProfileViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 9/4/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import IGListKit
import RxCocoa
import RxSwift
import SwiftyJSON
import Moya
class MyProfileViewModel: BaseViewModel {
    
    var profileDescription: ListDiffable = "profile" as ListDiffable
    var interactiveUsers: ListDiffable = "interactive" as ListDiffable
    var joiningContests: ListDiffable = "availablecontests" as ListDiffable
    var closedContests: ListDiffable = "closedcontest" as ListDiffable
    
    var user = BehaviorRelay<User?>(value: nil)
    var uid: Int?
    var covers: [String]?
    var activeAlbumContest = BehaviorRelay<[UserAlbumContest]?>(value: nil)
    
    override init() {
        super.init()
    }
    
    var listAdaper: [ListDiffable] {
        return [profileDescription, interactiveUsers, joiningContests, closedContests]
    }
    
    func fetchProfile() {
        let api = UserAPI.fetchProfile
        UserAPIProvider.rx.requestGetObject(ofType: User.self, api).subscribe(onNext: { [weak self] (response) in
            guard let self = self, let response = response else { return }
            if let user = response.result {
                self.user.accept(user)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func fetchUserProfile(completion: CompletionBlock?) {
        guard let uid = self.uid else { return }
        self.isLoading.accept(true)
        let api = UserAPI.fetchUserProfile(uid: uid)
        UserAPIProvider.rx.requestGetObject(ofType: User.self, api).subscribe(onNext: { [weak self] (response) in
            guard let self = self, let response = response else { return }
            self.isLoading.accept(false)
            if let error = response.error {
                completion?(nil, error)
            }
            
            if let user = response.result {
                self.user.accept(user)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func getActiveAlbumContest() {

        let api = ContestAPI.getUserActiveGalleries(uid: self.user.value?.uid)
        ContestAPIProvider.rx.requestGetArray(ofType: UserAlbumContest.self, api).subscribe(onNext: { [weak self] (response) in
            guard let self = self, let response = response else { return }
            self.activeAlbumContest.accept(response.result)
            
            for item in response.result {
                let api = ContestAPI.getUserPost(contest: item.key, uid: self.user.value?.uid, index: 0, limit: 5)
                ContestAPIProvider.rx.request(api, disposeBag: nil, callbackQueue: nil, keypath: nil).subscribe(onNext: { (dataResponse) in
                    guard let postJSON = dataResponse, let json = postJSON.json else { return }
                    let list = json[Constant.defaultKeypathForItem]["posts"].arrayValue
                    let posts = list.compactMap({ GalleryThumbnail(json: $0 )})
                    let albums = self.activeAlbumContest.value
                    let album = albums?.first(where: { $0.key == item.key })
                    album?.posts = posts
                    self.activeAlbumContest.accept(albums)
                }).disposed(by: self.disposeBag)
            }
            
        }).disposed(by: self.disposeBag)
    }

}
