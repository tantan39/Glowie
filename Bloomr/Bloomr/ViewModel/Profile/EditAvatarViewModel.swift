//
//  EditAvatarViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 9/11/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import RxCocoa
import RxSwift

enum AlbumType {
    case device
    case upload
}

enum EditType {
    case avatar
    case cover
}

class EditAvatarViewModel: BaseViewModel {
    var selectedAlbumType = BehaviorRelay<AlbumType>(value: .device)
    let galleryViewModel = GalleryViewModel()
    var editType = BehaviorRelay<EditType>(value: .avatar)
    let joinContestSuccess = BehaviorRelay<Bool>(value: false)
    
    func uploadAvatar(_ photo: UIImage, completionBlock: CompletionBlock?) {
        self.isLoading.accept(true)
        let contest = AppManager.shared.selectedContest
        let api = PhotoAPI.uploadAvatar(image: photo, contest: "vn")
        PhotoAPIProvider.rx.requestGetObject(ofType: Photo.self, api).subscribe(onNext: { [weak self] (response) in
            guard let self = self, let response = response else { return }
            self.isLoading.accept(false)
            if let error = response.error {
                completionBlock?(nil, error)
                return
            }
            if let object = response.result {
                completionBlock?(object, nil)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func joinContest(callback: ((ServiceErrorAPI?) -> Void)?) {

    }
}
