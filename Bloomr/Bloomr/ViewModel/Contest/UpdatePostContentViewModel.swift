//
//  UpdatePostContentViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/28/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift
import Photos

class UpdatePostContentViewModel: BaseViewModel {
    let selectedIndex = BehaviorRelay<Int?>(value: nil)
    var assets: [PHAsset]?
    var mediaSource: MediaSource = .none
    var captureImage: UIImage?
    var posts = BehaviorRelay<[ContentPostUpload]>(value: [])
    var createPostSuccess = BehaviorRelay<Bool>(value: false)
    var joinContestSuccess = BehaviorRelay<Bool>(value: false)
    let audioThumbnails: [UIImage] = [
        UIImage(named: "icon-audio-bg1")!,
        UIImage(named: "icon-audio-bg2")!,
        UIImage(named: "icon-audio-bg3")!,
        UIImage(named: "icon-audio-bg4")!
    ]
    var audioUrl: String?
    
    var contestFormat: ContestItemFormatType {
        let contest = AppManager.shared.selectedContest
        return contest?.contestFormat ?? .all
    }
    
    init(galleryViewModel: GalleryViewModel?, audioUrl: String? = nil) {
        super.init()
        
        switch self.contestFormat {
        case .audio:
            self.audioUrl = audioUrl
            let post = ContentPostUpload(thumbnail: UIImage(named: "icon-audio-bg-default"), media_id: nil, caption: nil, contest: self.contestSelected?.key, type: .audio)
            post?.title = self.audioUrl?.lastPathComponent
            self.posts.accept([post!])
        case .video:
            self.configVideoPost(galleryViewModel)
        case .photo, .all:
            self.configPhotoPost(galleryViewModel)
        }

    }
    
    func uploadPhoto(callback: ((ServiceErrorAPI?) -> Void)?) {

        let posts = self.posts.value
        if posts.count > 0 {
            var photos: [Photo] = []
                self.isLoading.accept(true)
            DispatchQueue.global().async {
                let dispatchGroup = DispatchGroup()
                for (index, post) in posts.enumerated() {
                    dispatchGroup.enter()
                    
                    if post.contentType == .photo {
                        let request = PhotoAPIProvider.rx.requestGetObject(ofType: Photo.self, PhotoAPI.uploadPhoto(image: post.thumbnailImage ?? UIImage()) )
                        request.subscribe(onNext: { (response) in
                            guard let response = response else { return }
                            if let photo = response.result {
                                photos.append(photo)
                                post.media_id = photo.id
                            }
                            if let _ = response.error {
                                dispatchGroup.suspend()
                            }
                            dispatchGroup.leave()
                            
                        }).disposed(by: self.disposeBag)
                        
                    } else if post.contentType == .audio {
                        self.uploadAudio { (audio, error) in
                            if let audio = audio as? Audio {
                                post.media_id = audio.audioId
                            }
                            
                            if let _ = error {
                                dispatchGroup.suspend()
                            }
                            dispatchGroup.leave()
                        }
                    } else {
                        guard let assets = self.assets, let video = assets[index].getVideoDataFromPHAsset() else { return }
                        let request = MediaAPIProvider.rx.requestGetObject(ofType: Video.self, MediaAPI.uploadVideo(data: video))
                        request.subscribe(onNext: { (response) in
                            guard let response = response else { return }
                              if let video = response.result {
                                post.media_id = video.videoId
                              }
                            if let _ = response.error {
                                  dispatchGroup.suspend()
                              }
                              dispatchGroup.leave()
                        }).disposed(by: self.disposeBag)
                    }
                    _ = dispatchGroup.wait()
                }
                
                dispatchGroup.notify(queue: .main) {
                    logDebug("All tasks are completed")
                    if AppManager.shared.selectedContest?.joinContest ?? false {
                        self.createPost { (_, error) in
                            if let error = error {
                                callback?(error)
                            }
                        }
                    } else {
                        let posts = self.posts.value
                        self.joinContest(mediaID: posts.first?.media_id, completion: nil)
                    }
                }
            }
        }
    }
    
    private func configPhotoPost(_ galleryViewModel: GalleryViewModel?) {
        self.assets = galleryViewModel?.selectedAssets
        self.mediaSource = galleryViewModel?.mediaSource.value ?? .none
        self.captureImage = galleryViewModel?.captureImage.value
        
        var images: [UIImage] = []
        
        switch self.mediaSource {
        case .camera:
            if let image = self.captureImage {
                images.append(image)
            }
        case .deviceAlbum:
            images = self.assets?.compactMap({ $0.getImageFromPHAsset() }) ?? []
        default:
            return
        }
        
        let posts = images.compactMap({ ContentPostUpload(thumbnail: $0, media_id: "", caption: "", contest: self.contestSelected?.key, type: .photo) })
        self.posts.accept(posts)
    }
    
    func uploadAudio(completion: CompletionBlock?) {
        guard let audioURL = self.audioUrl, let url = URL(string: audioURL) else { return }
        do {
            self.isLoading.accept(true)
            let data = try Data(contentsOf: url, options: .dataReadingMapped)
            let api = MediaAPI.uploadAudio(data: data)
            MediaAPIProvider.rx.requestGetObject(ofType: Audio.self, api).subscribe(onNext: { [weak self] (response) in
                guard let self = self, let response = response else { return }
                self.isLoading.accept(false)
                if let error = response.error {
                    completion?(nil, error)
                }
                if let audio = response.result {
                    completion?(audio, nil)
                    // Upload avatar if not join contest yet
                    if let contest = AppManager.shared.selectedContest, !contest.joinContest {
                        self.joinContest(mediaID: audio.audioId, completion: nil)
                    } else {
                        let posts = self.posts.value
                        posts.first?.media_id = audio.audioId
                        self.posts.accept(posts)
                        self.createPost { (result, error) in
                            if let error = error {
                                completion?(nil, error)
                            }
                            if let result = result as? PostItem {
                                completion?(result, nil)
                            }
                        }
                    }
                }
                
            }).disposed(by: self.disposeBag)
                
        } catch {
            logDebug(error.localizedDescription)
        }
    }
    
    func configVideoPost(_ galleryViewModel: GalleryViewModel?) {
        self.assets = galleryViewModel?.selectedAssets
        self.mediaSource = galleryViewModel?.mediaSource.value ?? .none
        self.captureImage = galleryViewModel?.captureImage.value
        
        var images: [UIImage] = []
        
        switch self.mediaSource {
        case .camera:
            if let image = self.captureImage {
                images.append(image)
            }
        case .deviceAlbum:
            images = self.assets?.compactMap({ $0.getAssetThumbnail(size: CGSize(width: 300, height: 300))}) ?? []
        default:
            return
        }
        
        let posts = images.compactMap({ ContentPostUpload(thumbnail: $0, media_id: "", caption: "", contest: self.contestSelected?.key, type: .video) })
        self.posts.accept(posts)
    }
    
    func uploadVideo(completion: CompletionBlock?) {
        
    }
    
    func joinContest(mediaID: String?, completion: CompletionBlock?) {
        guard let mediaID = mediaID else { return }
        let contest = AppManager.shared.selectedContest
        let api = ContestAPI.joinRace(key: contest?.key ?? "", media_id: mediaID)
        ContestAPIProvider.rx.requestCheckResult(api).subscribe(onNext: { [weak self] (response) in
            guard let _ = self else { return }
            self?.isLoading.accept(false)
            if let error = response?.error {
                completion?(nil, error)
                return
            }
            
            if let result = response?.result {
                completion?(result, nil)
                AppManager.shared.selectedContest?.joinContest = true
                self?.joinContestSuccess.accept(true)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func createPost(completion: CompletionBlock?) {
        self.isLoading.accept(false)
        let posts = self.posts.value
        let api = PostAPI.createPost(posts: posts)
        PostAPIProvider.rx.requestGetObject(ofType: PostItem.self, api).subscribe(onNext: { (response) in
            guard let response = response else { return }
            if let error = response.error {
                completion?(nil, error)
            }
            
            if let post = response.result {
                completion?(post, nil)
                self.createPostSuccess.accept(true)
            }
            
        }).disposed(by: self.disposeBag)
    }
}
