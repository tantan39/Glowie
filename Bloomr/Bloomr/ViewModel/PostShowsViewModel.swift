//
//  PostShowsViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

class PostShowsViewModel: BaseViewModel {
    var isOffSpeaker = BehaviorRelay<Bool>(value: true)
    var isPauseMedia = BehaviorRelay<Bool>(value: true)
    var mediaManager: MediaManager?
    var userPosts: [UserPostItemProtocol]? = []
    var presentingPost = BehaviorRelay<GalleryThumbnail?>(value: nil)
    var nextItem = BehaviorRelay<GalleryThumbnail?>(value: nil)
    var dataSouce = BehaviorRelay<[GalleryThumbnail]?>(value: nil)
    var postDetails = BehaviorRelay<PostDetails?>(value: nil)
    
    var total: Int {
        return self.dataSouce.value?.count ?? 0
    }
    
    override init() {
        super.init()
        let postItem = PostItem(json: [:])
        postItem?.type = .audio
        
        let postItem1 = PostItem(json: [:])
        postItem1?.type = .video
        
        let postItem2 = PostItem(json: [:])
        postItem2?.type = .photo
        
        let user1 = UserPosts(postItems: [postItem1!, postItem2!, postItem!], user: "a")
        let user2 = UserPosts(postItems: [postItem1!, postItem2!], user: "b")
        
        self.userPosts?.append(user1)
        self.userPosts?.append(user2)
    }
    
    init(galleries: [GalleryThumbnail]?, selectedItem: GalleryThumbnail?) {
        super.init()
        self.dataSouce.accept(galleries)
        self.presentingPost.accept(selectedItem)
    }
    
    func configMediaManger(type: MediaType, url: String?) {
        if type == .audio {
//            let url = "https://s3.amazonaws.com/kargopolov/kukushka.mp3"
            if let url = url {
                mediaManager = MediaManager(url: url, type: .audio)
            }
        } else {
//            let url = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
            if let url = url {
                mediaManager = MediaManager(url: url, type: .video, playerContainer: nil)
            }
            
        }
    }

    func getPostDetail(postID: String?, completion: CompletionBlock?) {
        guard let postID = postID else { return }
        let api = PostAPI.getPostDetail(id: postID)
        PostAPIProvider.rx.requestGetObject(ofType: PostDetails.self, api).subscribe(onNext: { [weak self] (response) in
            guard let self = self, let response = response else { return }
            if let error = response.error {
                completion?(nil, error)
                return
            }
            if let object = response.result {
                self.postDetails.accept(object)
                completion?(object, nil)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func setAudioOutputSpeaker(_ on: Bool) {
        self.mediaManager?.enableSpeaker(on)
    }
}
